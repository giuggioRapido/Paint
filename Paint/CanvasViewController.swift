//
//  ViewController.swift
//  Paint
//
//  Created by Christopher Shea on 6/6/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
        

    //MARK: Touch Events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first {
            lastPoint = touch.locationInView(canvasView)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.locationInView(canvasView)
            canvasView.drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
           canvasView.drawLineFrom(lastPoint, toPoint: lastPoint)
        }
    }
    
}

