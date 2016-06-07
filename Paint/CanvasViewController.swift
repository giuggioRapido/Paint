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
    @IBOutlet var colorPalette: [UIButton]!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for color in colorPalette {
            color.hidden = true
        }
    }
    
    
    
    
    //MARK: IBActions
    @IBAction func toggleColorPalette(sender: UIButton) {
        let isHidden = colorPalette.first?.hidden
        
        for color in colorPalette {
            color.hidden = !isHidden!
        }
    }
    
    @IBAction func setBrushColor(sender: UIButton) {
        canvasView.brushColor = sender.backgroundColor!
    }

    
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

