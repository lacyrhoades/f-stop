//
//  FilterApplier.swift
//  f-stop
//
//  Created by Lacy Rhoades on 7/29/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import UIKit

class ImageFilterApplier {
    static func applyFilter(filter: Filter, toImage: UIImage) -> UIImage {
        var coreImage = CIImage(CGImage:toImage.CGImage!)
        
        if let effect = filter.getEffect(.CIExposure) {
            let exposureFilter: CIFilter! = CIFilter(name: "CIExposureAdjust")
            exposureFilter.setValue(coreImage, forKey:kCIInputImageKey)
            exposureFilter.setValue(effect.value, forKey:"inputEV")
            coreImage = exposureFilter.outputImage!
        }
        
        let colorFilter: CIFilter! = CIFilter(name: "CIColorControls")
        colorFilter.setValue(coreImage, forKey: kCIInputImageKey)
        var changedColor = false

        if let effect = filter.getEffect(.CIBrightness) {
            colorFilter.setValue(effect.value, forKey: kCIInputBrightnessKey)
            changedColor = true
        }
        
        if let effect = filter.getEffect(.CIContrast) {
            colorFilter.setValue(effect.value, forKey: kCIInputContrastKey)
            changedColor = true
        }
        
        if let effect = filter.getEffect(.CISaturation) {
            colorFilter.setValue(effect.value, forKey: kCIInputSaturationKey)
            changedColor = true
        }
        
        if changedColor {
            coreImage = colorFilter.outputImage!
        }
        
        if let effect = filter.getEffect(.CIHue) {
            let hueFilter: CIFilter! = CIFilter(name: "CIHueAdjust")
            hueFilter.setValue(coreImage, forKey:kCIInputImageKey)
            hueFilter.setValue(effect.value, forKey:kCIInputAngleKey)
            coreImage = hueFilter.outputImage!
        }
        
        let highlightShadowFilter: CIFilter! = CIFilter(name:"CIHighlightShadowAdjust")
        highlightShadowFilter.setValue(coreImage, forKey: kCIInputImageKey)
        var changedHSF = false
        
        if let effect = filter.getEffect(.CIInputShadow) {
            changedHSF = true
            highlightShadowFilter.setValue(effect.value, forKey:"inputShadowAmount")
        }
        
        if let effect = filter.getEffect(.CIInputHighlight) {
            changedHSF = true
            highlightShadowFilter.setValue(effect.value, forKey:"inputHighlightAmount")
        }

        if changedHSF {
            coreImage = highlightShadowFilter.outputImage!
        }

        if let effect = filter.getEffect(.CISharpness) {
            let sharpFilter: CIFilter! = CIFilter(name: "CISharpenLuminance")
            sharpFilter.setValue(coreImage, forKey:kCIInputImageKey)
            sharpFilter.setValue(effect.value, forKey:"inputSharpness")
            coreImage = sharpFilter.outputImage!
        }
        
        if let effect = filter.getEffect(.CIVignette) {
            let vinFilter: CIFilter! = CIFilter(name: "CIVignette")
            vinFilter.setValue(coreImage, forKey:kCIInputImageKey)
            vinFilter.setValue(effect.value, forKey:kCIInputIntensityKey)
            vinFilter.setValue(25.0, forKey:"inputRadius")
            coreImage = vinFilter.outputImage!
        }
    
        if let effect = filter.getEffect(.CISepia) {
            let sepiaFilter: CIFilter! = CIFilter(name: "CISepiaTone")
            sepiaFilter.setDefaults()
            sepiaFilter.setValue(coreImage, forKey: kCIInputImageKey)
            sepiaFilter.setValue(effect.value, forKey: kCIInputIntensityKey)
            coreImage = sepiaFilter.outputImage!
        }
        
        let context = CIContext(options: nil)
        let cgiimage = context.createCGImage(coreImage, fromRect:coreImage.extent)
        
        return UIImage(CGImage: cgiimage, scale: toImage.scale, orientation: toImage.imageOrientation)
    }
}