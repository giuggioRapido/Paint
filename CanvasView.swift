//
//  CanvasView.swift
//  Paint
//
//  Created by Christopher Shea on 6/6/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import UIKit

protocol CanvasViewDelegate {
    func canvasViewDidCompleteBrushStroke(view: CanvasView)
}

class CanvasView: UIImageView {
    var brush = Brush()
    var pendingBrushColor: UIColor?
    var swiped = false
    var lastPoint = CGPoint.zero
    var delegate: CanvasViewDelegate?

    var isErasing = false {
        willSet {
            switch newValue {
            case true:
                brush.color = backgroundColor!
            case false:
                if let pendingColor = pendingBrushColor {
                    brush.color = pendingColor
                    pendingBrushColor = nil
                } else {
                    brush.color = brush.previousColor
                }
            }
        }
    }

    internal func setBrushColor(color: UIColor) {
        brush.color = color
    }

    internal func setBrushSize(size: CGFloat) {
        brush.size = size
    }

    // MARK: Touch Events
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

        delegate?.canvasViewDidCompleteBrushStroke(self)
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    }

    // MARK: Drawing
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {

        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()

        layer.renderInContext(context!)

        let path = UIBezierPath()
        path.lineCapStyle = .Round
        path.lineWidth = brush.size
        brush.color.setStroke()

        path.moveToPoint(CGPointMake(fromPoint.x, fromPoint.y))
        path.addLineToPoint(CGPointMake(toPoint.x, toPoint.y))

        path.stroke()
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = 1.0
        
        UIGraphicsEndImageContext()
    }

    func clear() {
        self.image = nil
    }
}
