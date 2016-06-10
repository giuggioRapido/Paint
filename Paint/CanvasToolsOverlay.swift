//
//  CanvasToolsOverlay.swift
//  Paint
//
//  Created by Christopher Shea on 6/10/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import UIKit

class CanvasToolsOverlay: UIView {

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
                return true
            }
        }
        return false
    }
    
}
