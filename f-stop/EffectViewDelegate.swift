//
//  EffectViewDelegate.swift
//  f-stop
//
//  Created by Lacy Rhoades on 7/29/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import UIKit

protocol EffectViewDelegate: class {
    func changeEffect(type: EffectType, toValue val: Float)
}
