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
    @IBOutlet var brushSizePalette: [UIButton]!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var colorPaletteToggle: UIButton!
    @IBOutlet weak var blackColorButton: UIButton!
    @IBOutlet weak var mediumBrushButton: UIButton!
    
    var currentlySelectedColorButton: UIButton? {
        didSet {
            if let newButton = currentlySelectedColorButton {
                newButton.layer.borderColor = UIColor.blueColor().CGColor
                newButton.layer.borderWidth = 2.0
                
                if let oldButton = oldValue {
                    oldButton.layer.borderColor = nil
                    oldButton.layer.borderWidth = 0
                }
            }
        }
    }
    
    var currentlySelectedSizeButton: UIButton? {
        didSet {
            if let newButton = currentlySelectedSizeButton {
                newButton.layer.borderColor = UIColor.blueColor().CGColor
                newButton.layer.borderWidth = 2.0
                
                if let oldButton = oldValue {
                    oldButton.layer.borderColor = nil
                    oldButton.layer.borderWidth = 0
                }
            }
        }
    }
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for color in colorPalette {
            color.hidden = true
        }
        
        for brush in brushSizePalette {
            brush.hidden = true
        }
        
        clearButton.hidden = true
        currentlySelectedColorButton = blackColorButton
        currentlySelectedSizeButton = mediumBrushButton
    }
    
    
    //MARK: IBActions
    @IBAction func toggleColorPalette(sender: UIButton) {
        let isHidden = colorPalette.first?.hidden
        for color in colorPalette {
            color.hidden = !isHidden!
        }
    }
    
    @IBAction func toggleBrushSizePalette(sender: UIButton) {
        let isHidden = brushSizePalette.first?.hidden
        for size in brushSizePalette {
            size.hidden = !isHidden!
        }
    }
    
    @IBAction func toggleEraser(sender: UIButton) {
        let isSelected = sender.selected
        sender.selected = !isSelected
        canvasView.isErasing = sender.selected
        clearButton.hidden = !sender.selected
    }
    
    @IBAction func setBrushColor(sender: UIButton) {
        let selectedColor = sender.backgroundColor!
        
        if canvasView.isErasing {
            canvasView.pendingBrushColor = selectedColor
        } else {
            canvasView.brushColor = selectedColor
        }
        
        colorPaletteToggle.setTitleColor(selectedColor, forState: .Normal)
        currentlySelectedColorButton = sender
    }
    
    @IBAction func setBrushSize(sender: UIButton) {
        let size = (sender.titleLabel?.font.pointSize)!
        canvasView.brushSize = size
        currentlySelectedSizeButton = sender
    }
    
    @IBAction func clearCanvas(sender: AnyObject) {
        canvasView.clear()
        toggleEraser(eraseButton)
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

