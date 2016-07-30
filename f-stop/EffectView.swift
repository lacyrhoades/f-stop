//
//  EffectView.swift
//  f-stop
//
//  Created by Lacy Rhoades on 7/29/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import UIKit

class EffectView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    var nameLabel = UILabel()
    var valueLabel = UILabel()
    var slider = UISlider()
    func setup() {
        
        nameLabel.text = "Effect"
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        valueLabel.textColor = UIColor.whiteColor()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(valueLabel)
        
        slider.addTarget(self, action: #selector(sliderFinishedChanging), forControlEvents: .TouchUpInside)
        slider.addTarget(self, action: #selector(sliderDidChange), forControlEvents: .ValueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)
        
        self.setupConstraints()
    }
    
    func reset() {
        if var effect = self.effect {
            effect.value = effect.initialValue
            self.effect = effect
            self.slider.value = effect.value
        }
    }
    
    func setupConstraints() {
        let metrics = ["margin": 0]
        let views = [
            "nameLabel": nameLabel,
            "valueLabel": valueLabel,
            "slider": slider
        ]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[nameLabel][slider(==14.0)]-|", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[nameLabel]-|", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[slider]-|", options: [], metrics: metrics, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[valueLabel][slider]", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[valueLabel]-|", options: [], metrics: metrics, views: views))
    }
    
    var effect: Effect? {
        willSet {
            if let newEffect = newValue {
                if effect == nil {
                    self.nameLabel.text = newEffect.title
                    self.slider.minimumValue = newEffect.minimumValue
                    self.slider.maximumValue = newEffect.maximumValue
                    self.slider.value = newEffect.initialValue
                }
                
                self.valueLabel.text = newEffect.valueString
            }
            
            self.effect = newValue
        }
        
    }
    
    weak var effectDelegate: EffectViewDelegate?
    func sliderFinishedChanging() {
        guard var effect = self.effect else {
            return
        }
        effect.value = self.slider.value
        self.effect = effect
        self.effectDelegate?.changeEffect(effect.effectType, toValue: effect.value)
    }
    
    func sliderDidChange() {
        self.valueLabel.text = Effect.valueString(self.slider.value)
    }
}
