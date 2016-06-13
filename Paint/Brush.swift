//
//  Brush.swift
//  Paint
//
//  Created by Christopher Shea on 6/9/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import Foundation
import UIKit

internal struct Brush {
    var color = UIColor.blackColor() {
        didSet {
            previousColor = oldValue
        }
    }
    var size: CGFloat = 20.0
    var previousColor = UIColor.blackColor()
}