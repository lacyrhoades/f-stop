//
//  MainMenuVC.swift
//  grayscale
//
//  Created by Lacy Rhoades on 7/28/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {
    var scrollView = UIScrollView()
    
    // background
    var backgroundImage = UIImageView()
    
    // pull-down menu
    var galleryVC = GalleryVC()
    var galleryView: UIView {
        get {
            return self.galleryVC.view
        }
    }
    
    // center view (mostly just clear)
    var blankView = UIView()
    
    // pull-up menu
    var configVC = FilterControlsVC()
    var configView: UIView! {
        get {
            return self.configVC.view
        }
    }
    
    var rawImage: UIImage? = nil
    var currentFilter: Filter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentFilter = self.blankFilter()
        self.configVC.mainMenuController = self
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.backgroundImage.contentMode = .ScaleAspectFit
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.backgroundImage)
        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        
        self.galleryVC.selectionDelegate = self
        self.galleryVC.embeddedScrollViewDelegate = self
        self.galleryView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.galleryView)
        
        self.addChildViewController(self.galleryVC)
        self.galleryVC.didMoveToParentViewController(self)
        
        self.blankView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.blankView)
        
        self.configView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.configView)
        
        self.addChildViewController(self.configVC)
        self.configVC.didMoveToParentViewController(self)
        
        self.setupConstraints(self.view.bounds.size)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.galleryVC.reload()
    }
    
    func setupConstraints(size: CGSize) {
        let metrics = [
            "margin": 0,
            "height": size.height,
            "width": size.width
        ]
        
        let views = [
            "backgroundImage": self.backgroundImage,
            "scrollView": self.scrollView,
            "galleryView": self.galleryView,
            "blankView": self.blankView,
            "configView": self.configView,
            ]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundImage]|", options: [], metrics: metrics, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundImage]|", options: [], metrics: metrics, views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: [], metrics: metrics, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: [], metrics: metrics, views: views))
        
        self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[galleryView]|", options: [], metrics: metrics, views: views))
        self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blankView]|", options: [], metrics: metrics, views: views))
        self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[configView]|", options: [], metrics: metrics, views: views))
        
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.galleryView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.blankView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.configView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width))
        
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.galleryView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.blankView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.configView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height))
        
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.galleryView, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.blankView, attribute: .Top, relatedBy: .Equal, toItem: self.galleryView, attribute: .Bottom, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.configView, attribute: .Top, relatedBy: .Equal, toItem: self.blankView, attribute: .Bottom, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.configView, attribute: .Bottom, relatedBy: .Equal, toItem: self.scrollView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    override func viewWillAppear(animated: Bool) {
        let height = self.view.bounds.height
        let width = self.view.bounds.width
        self.scrollView.contentSize = CGSize(width: width, height: 3 * height)
        
        self.scrollToCenter(false)
        
        self.unlock()
        
        if self.backgroundImage.image == nil {
            self.galleryVC.loadFirstImage()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}

extension MainMenuVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0.0 {
            self.lock()
        }
    }
}

extension MainMenuVC: EmbeddedScrollViewDelegate {
    func lock() {
        self.scrollView.scrollEnabled = false
    }
    
    func unlock() {
        self.scrollView.scrollEnabled = true
    }
    
    func setContentOffset(offset: CGPoint) {
        self.scrollView.contentOffset = offset
    }
    
    func scrollToCenter(animated: Bool) {
        let height = self.view.bounds.height
        let centerOffset = CGPoint(x: 0, y: height)
        self.scrollView.setContentOffset(centerOffset, animated: true)
        self.unlock()
    }

}

extension MainMenuVC: GalleryPhotoSelectionDelegate {
    func imageWasSelected(image: UIImage) {
        self.rawImage = image
        self.scrollToCenter(true)
        main_thread {
            self.backgroundImage.image = image
            self.currentFilter = self.blankFilter()
            self.applyFilter(self.currentFilter)
            self.configVC.reset()
        }
    }
}

extension MainMenuVC: EffectViewDelegate {
    func changeEffect(type: EffectType, toValue val: Float) {
        self.currentFilter = self.currentFilter.changeEffect(type, toValue: val)
        self.applyFilter(self.currentFilter)
    }
}

extension MainMenuVC {

    func applyFilter(filter: Filter) {
        guard let image = self.rawImage else {
            print("no raw image")
            return
        }
        
        background_thread {
            let filtered = ImageFilterApplier.applyFilter(filter, toImage: image)
            main_thread {
                self.backgroundImage.image = filtered
            }
        }
    }
}

extension MainMenuVC {
    func blankFilter() -> Filter {
        return Filter()
    }
}