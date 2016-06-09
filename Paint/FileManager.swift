//
//  FileManager.swift
//  Paint
//
//  Created by Christopher Shea on 6/9/16.
//  Copyright © 2016 Christopher Shea. All rights reserved.
//

import Foundation

struct FileManager {
    
    static func saveImageToDocuments(imageData: NSData) {
        
        let imageName = "image.png"
        let docURL = documentDirectoryURL()
        let imageURL = docURL?.URLByAppendingPathComponent(imageName)
        
        if let imagePath = imageURL?.path {
            let manager = NSFileManager.defaultManager()
            let success = manager.createFileAtPath(imagePath, contents: imageData, attributes: nil)
            if !success { print("image save failed") }
        }
    }
    
    static func loadImageFromDocuments() -> NSData? {
        
        let imageName = "image.png"
        let docURL = documentDirectoryURL()
        let imageURL = docURL?.URLByAppendingPathComponent(imageName)
        
        guard let imagePath = imageURL?.path else {
            print("could not create image path")
            return nil
        }
        
        let manager = NSFileManager.defaultManager()
        let imageData = manager.contentsAtPath(imagePath)
        
        return imageData
    }
    
    static func documentDirectoryURL() -> NSURL? {
        let manager = NSFileManager.defaultManager()
        let URLs = manager.URLsForDirectory(.DocumentDirectory,
                                            inDomains: .UserDomainMask)
        
        guard let documentURL = URLs.first else  {
            print("Could not get document directory URL")
            return nil
        }
        
        return documentURL
    }
}

