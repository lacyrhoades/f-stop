//
//  Filter.swift
//  f-stop
//
//  Created by Lacy Rhoades on 7/29/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import Foundation

struct Filter {
    var effects: [Effect] = []
    
    init() {
        self.effects = [
            Effect(name: "Exposure", type: .CIExposure, min: -5.0, max: 5.0, defaultValue: 0.0),
            Effect(name: "Brightness", type: .CIBrightness, min: -1.0, max: 1.0, defaultValue: 0.0),
            Effect(name: "Contrast", type: .CIContrast, min: 0.0, max: 2.0, defaultValue: 1.0),
            Effect(name: "Highlights", type: .CIInputHighlight, min: -1.0, max: 1.0, defaultValue: 0.0),
            Effect(name: "Shadows", type: .CIInputShadow, min: -1.0, max: 1.0, defaultValue: 0.0),
            Effect(name: "Saturation", type: .CISaturation, min: -2.0, max: 2.0, defaultValue: 0.0),
            Effect(name: "Hue", type: .CIHue, min: -1.0, max: 1.0, defaultValue: 0.0),
            Effect(name: "Sepia Tone", type: .CISepia, min: 0.0, max: 1.0, defaultValue: 0.0),
            Effect(name: "Sharpness", type: .CISharpness, min: -10.0, max: 10.0, defaultValue: 0.0),
            Effect(name: "Vignette", type: .CIVignette, min: 0.0, max: 1.0, defaultValue: 0.0),
        ]
    }
    
    func getEffect(type: EffectType) -> Effect? {
        for effect in self.effects {
            if effect.effectType == type {
                return effect
            }
        }
        
        return nil
    }
    
    mutating func setEffect(newEffect: Effect) {
        let index = self.effects.indexOf({ (effect) -> Bool in
            return effect.effectType == newEffect.effectType
        })
        
        if let index = index {
            self.effects[index] = newEffect
        } else {
            print ("effect not found")
        }
    }
    
    func changeEffect(type: EffectType, toValue val: Float) -> Filter {
        if var effect = self.getEffect(type) {
            var filter = self
            effect.value = val
            filter.setEffect(effect)
            return filter
        } else {
            return self
        }
    }
}
