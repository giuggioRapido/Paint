//
//  CanvasView.swift
//  Paint
//
//  Created by Christopher Shea on 6/6/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import UIKit

class CanvasView: UIImageView {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    var brushColor = UIColor.blackColor() { didSet { previousBrushColor = oldValue } }
    var previousBrushColor = UIColor.blackColor()
    var pendingBrushColor: UIColor?
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
    
    var brushSize: CGFloat = 20.0
    
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
    
}
