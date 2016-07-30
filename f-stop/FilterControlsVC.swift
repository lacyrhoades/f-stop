//
//  FilterControlsVC.swift
//  grayscale
//
//  Created by Lacy Rhoades on 7/28/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class FilterControlsVC: UIViewController {
    
    var effectsWrapperView = UIView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clearColor()
        
        self.effectsWrapperView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.effectsWrapperView)
        
        for effect in self.filter.effects {
            self.addEffectControl(effect)
        }
        
        self.setupConstraints()
    }
    
    var effectViews: [EffectView] = []
    weak var mainMenuController: MainMenuVC!
    func addEffectControl(effect: Effect) {
        let view = EffectView()
        
        view.effectDelegate = self.mainMenuController
        view.effect = effect
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.effectsWrapperView.addSubview(view)
        
        if let last = self.effectViews.last {
            self.attachViewTop(view, toBottomOf: last)
        }
        
        self.maximizeHorizontally(view)
        
        self.effectViews.append(view)
    }
    
    func reset() {
        for view: EffectView in self.effectViews {
            view.reset()
        }
    }
    
    var filter: Filter {
        get {
            return self.mainMenuController.currentFilter
        }
    }
    
    func setupConstraints() {
        if let first = self.effectViews.first, last = self.effectViews.last {
            self.attachViewTop(first, toTopOf: self.effectsWrapperView)
            self.attachViewBottom(last, toBottomOf: self.effectsWrapperView)
        }
        
        self.maximizeHorizontally(self.effectsWrapperView)
        self.view.addConstraint(NSLayoutConstraint(item: self.effectsWrapperView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
    }
}

extension FilterControlsVC {
    func setHeight(view: UIView, height: CGFloat) {
        self.effectsWrapperView.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height))
    }
    
    func maximizeHorizontally(view: UIView) {
        guard let superview = view.superview  else {
            assert(false, "View has no superview")
            return
        }
        
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view]-|", options: [], metrics: [:], views: ["view": view]))
    }
    
    func attachViewTop(view: UIView, toTopOf otherView: UIView) {
        self.effectsWrapperView.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: otherView, attribute: .Top, multiplier: 1, constant: 0))
    }
    
    func attachViewBottom(view: UIView, toBottomOf otherView: UIView) {
        self.effectsWrapperView.addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: otherView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func attachViewTop(view: UIView, toBottomOf otherView: UIView) {
        self.effectsWrapperView.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: otherView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
}
