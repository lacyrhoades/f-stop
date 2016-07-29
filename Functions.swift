//
//  Functions.swift
//  grayscale
//
//  Created by Lacy Rhoades on 7/28/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import Foundation

func delay(delay: Double, closure: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}

func main_thread(closure: ()->()) {
    dispatch_async(dispatch_get_main_queue()) {
        closure()
    }
}

func background_thread(closure: ()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
        closure()
    }
}
