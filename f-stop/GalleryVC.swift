//
//  GalleryVC.swift
//  grayscale
//
//  Created by Lacy Rhoades on 7/28/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos
import GPUImage

class GalleryVC: UIViewController {
    weak var selectionDelegate: GalleryPhotoSelectionDelegate?
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(blurEffectView)
        
        self.view.transform = CGAffineTransformScale(self.view.transform, 1, -1)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 8.0, right: 0)
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.panGestureRecognizer.addTarget(self, action: #selector(collectionViewDidPan))
        self.collectionView.bounces = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(self.collectionView)
        
        self.collectionView.registerClass(PhotoViewCell.self, forCellWithReuseIdentifier: "PhotoCellIdent")
        
        self.setupCameraRoll()
    }
    
    func reload() {
        dispatch_async(dispatch_get_main_queue()) {
            self.setupCameraRoll()
            self.collectionView.reloadData()
        }
    }
    
    var assets: PHFetchResult!
    func setupCameraRoll() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    weak var embeddedScrollViewDelegate: EmbeddedScrollViewDelegate?
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == 0.0) {
            self.embeddedScrollViewDelegate?.unlock()
        } else {
            self.embeddedScrollViewDelegate?.lock()
        }
    }
    
    func collectionViewDidPan(gesture: UIPanGestureRecognizer) {
        let offset = self.collectionView.contentOffset
        
        guard offset.y == 0 else {
            return
        }
        
        var pan = gesture.translationInView(self.collectionView)
        
        guard pan.y > 0.0 else {
            return
        }
        
        self.embeddedScrollViewDelegate?.unlock()
        if (gesture.state == .Ended) {
            self.embeddedScrollViewDelegate?.scrollToCenter(true)
        } else {
            pan.x = 0.0
            self.embeddedScrollViewDelegate?.setContentOffset(pan)
        }
    }
    
    func loadFirstImage() {
        if self.assets.count > 0 {
            if let asset = self.assets[0] as? PHAsset {
                PHImageManager.defaultManager().requestImageDataForAsset(
                    asset,
                    options: nil, resultHandler: { (data, uti, orientation, info) in
                        if let data = data, image = UIImage(data: data) {
                            self.selectionDelegate?.imageWasSelected(image)
                        }
                })
            }
        }
    }
}


extension GalleryVC: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let asset = self.assets[indexPath.row] as? PHAsset {
            PHImageManager.defaultManager().requestImageDataForAsset(
                asset,
                options: nil, resultHandler: { (data, uti, orientation, info) in
                    if let data = data, image = UIImage(data: data) {
                        self.selectionDelegate?.imageWasSelected(image)
                    }
            })
        }
        
    }
}

extension GalleryVC: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let ident = "PhotoCellIdent"
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ident, forIndexPath: indexPath) as? PhotoViewCell else {
            assert(false, "Can't find cell")
            return UICollectionViewCell()
        }
        
        if let asset = self.assets[indexPath.row] as? PHAsset {
            PHImageManager.defaultManager().requestImageForAsset(asset,
                                                                 targetSize: CGSize(width: 500, height: 500),
                                                                 contentMode: .AspectFill,
                                                                 options: nil,
                                                                 resultHandler: { image, info in
                                                                    cell.image = image
            })
        }
        
        return cell
        
    }
}

extension GalleryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 16.0, height: 200.0)
    }
}

extension GalleryVC: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(changeInstance: PHChange) {
        self.reload()
        self.loadFirstImage()
    }
}

class PhotoViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1, -1)
        
        self.contentView.backgroundColor = UIColor.grayColor()
        self.imageView = UIImageView()
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.frame = self.bounds
        self.imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.contentView.addSubview(self.imageView)
        
        self.contentView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    var imageView: UIImageView!
    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
        }
    }
}
