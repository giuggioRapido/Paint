//
//  ViewController.swift
//  Paint
//
//  Created by Christopher Shea on 6/6/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView! {
        didSet {
            canvasView.delegate = self
        }
    }
    @IBOutlet var colorPalette: [UIButton]!
    @IBOutlet var brushSizePalette: [UIButton]!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var colorPaletteToggle: UIButton!
    @IBOutlet weak var blackColorButton: UIButton!
    @IBOutlet weak var mediumBrushButton: UIButton!

    var savedImage: UIImage?

    var currentlySelectedColorButton: UIButton? {
        didSet {
            if let newButton = currentlySelectedColorButton {
                highlightButton(newButton)
            }
            if let oldButton = oldValue {
                unhighlightButton(oldButton)
            }
        }
    }

    var currentlySelectedSizeButton: UIButton? {
        didSet {
            if let newButton = currentlySelectedSizeButton {
                highlightButton(newButton)
            }
            if let oldButton = oldValue {
                unhighlightButton(oldButton)
            }
        }
    }


    // MARK: Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUpDefaultUI()
    }

    func setUpDefaultUI() {
        if let savedImage = imageFromDocuments() {
            canvasView.image = savedImage
        }

        for color in colorPalette {
            color.hidden = true
        }

        for brush in brushSizePalette {
            brush.hidden = true
        }

        clearButton.hidden = true

        currentlySelectedColorButton = blackColorButton
        canvasView.setBrushColor(UIColor.blackColor())

        currentlySelectedSizeButton = mediumBrushButton
        canvasView.setBrushSize(10.0)

    }

    // MARK: IBActions
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
            canvasView.setBrushColor(selectedColor)
        }

        colorPaletteToggle.setTitleColor(selectedColor, forState: .Normal)
        currentlySelectedColorButton = sender
    }

    @IBAction func setBrushSize(sender: UIButton) {
        let size = (sender.titleLabel?.font.pointSize)!
        canvasView.setBrushSize(size)
        currentlySelectedSizeButton = sender
    }

    @IBAction func clearCanvas(sender: AnyObject) {
        canvasView.clear()
        toggleEraser(eraseButton)
    }

    @IBAction func restoreImage(sender: UIButton) {
        canvasView.clear()
        if let image = savedImage {
            canvasView.image = image
        }
    }

    @IBAction func sendToPhotos(sender: UIButton) {
        if let img = savedImage {
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(CanvasViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    // MARK: UI Feedback
    func highlightButton(button: UIButton) {
        button.layer.borderColor = UIColor.blueColor().CGColor
        button.layer.borderWidth = 2.0
    }

    func unhighlightButton(button: UIButton) {
        button.layer.borderColor = nil
        button.layer.borderWidth = 0
    }

    // MARK: Persistence
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        guard error == nil else {
            print(error)
            return
        }
        displayImageSavedAlert()
    }

    func displayImageSavedAlert() {
        let alert = UIAlertController(title: "Image saved to Photos", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction.init(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }

    func imageFromDocuments() -> UIImage? {
        if let imageData = FileManager.loadImageFromDocuments() {
            if let image = UIImage(data: imageData) {
                return image
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}


// MARK: CanvasViewDelegate
extension CanvasViewController: CanvasViewDelegate {
    func canvasViewDidCompleteBrushStroke(view: CanvasView) {
        savedImage = nil
        savedImage = canvasView.image
        guard let PNGImage = UIImagePNGRepresentation(savedImage!) else {
            print("Could not convert image to PNG")
            return
        }
        
        FileManager.saveImageToDocuments(PNGImage)
    }
}

