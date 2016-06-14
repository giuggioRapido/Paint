//
//  CanvasView.swift
//  Paint
//
//  Created by Christopher Shea on 6/6/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import UIKit

protocol CanvasViewDelegate: class {
    func canvasViewDidCompleteBrushStroke(view: CanvasView)
}

final class CanvasView: UIImageView {
    private var brush = Brush()

    var brushColor: UIColor {
        get { return brush.color }
        set { brush.color = newValue }
    }
    var brushSize: CGFloat {
        get { return brush.size }
        set { brush.size = newValue }
    }

    var pendingBrushColor: UIColor?
    private  var swiped = false
    private var lastPoint = CGPoint.zero
    weak var delegate: CanvasViewDelegate?

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
