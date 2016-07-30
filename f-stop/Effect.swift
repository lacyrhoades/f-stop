//
//  Effect.swift
//  f-stop
//
//  Created by Lacy Rhoades on 7/29/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import Foundation

enum EffectType {
    case CIExposure
    case CIBrightness
    case CIContrast
    case CISaturation
    case CISepia
    case CIHue
    case CIInputShadow
    case CIInputHighlight
    case CIVignette
    case CISharpness
}

enum EffectControlType {
    case Slider
}

struct Effect {
    var effectType: EffectType = .CISaturation
    var controlType: EffectControlType = .Slider
    var title: String = "Effect Title"
    var value: Float = 0
    var initialValue: Float = 0
    var minimumValue: Float = -1
    var maximumValue: Float = 1
    
    init(name: String, type: EffectType, min: Float, max: Float, defaultValue: Float) {
        self.title = name
        self.effectType = type
        self.minimumValue = min
        self.maximumValue = max
        self.initialValue = defaultValue
        self.value = defaultValue
    }
    
    var valueString: String {
        get {
            return String(format: "%0.1f", self.value)
        }
    }
    
    static func valueString(val: Float) -> String {
        return String(format: "%0.1f", val)
    }
}

