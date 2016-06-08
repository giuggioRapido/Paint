//
//  CanvasView.swift
//  Paint
//
//  Created by Christopher Shea on 6/6/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import UIKit

class CanvasView: UIImageView {
    
    var brushColor = UIColor.blackColor() { didSet { previousBrushColor = oldValue } }
    var previousBrushColor = UIColor.blackColor()
    var pendingBrushColor: UIColor?
    var swiped = false
    var lastPoint = CGPoint.zero
    var brushSize: CGFloat = 20.0
    

    var isErasing = false {
        willSet {
            switch newValue {
            case true:
                brushColor = self.backgroundColor!
            case false:
                if let pendingColor = pendingBrushColor {
                    brushColor = pendingColor
                    pendingBrushColor = nil
                } else {
                    brushColor = previousBrushColor
                }
            }
        }
    }
    
    
    //MARK: Touch Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self)
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
    }
    
    
    //MARK: Drawing
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.image?.drawInRect(CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, brushSize)
        CGContextSetStrokeColorWithColor(context, brushColor.CGColor)
        CGContextSetBlendMode(context, .Normal)
        
        CGContextStrokePath(context)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = 1.0
        
        UIGraphicsEndImageContext()
    }
    
    func clear() {
        self.image = nil
    }

}
