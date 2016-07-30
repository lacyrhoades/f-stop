//
//  EmbeddedScrollViewDelegate.swift
//  FoboBeta
//
//  Created by Lacy Rhoades on 6/29/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import UIKit

protocol EmbeddedScrollViewDelegate: class {
    func lock()
    func unlock()
    func scrollToCenter(animated: Bool)
    func setContentOffset(offset: CGPoint)
}