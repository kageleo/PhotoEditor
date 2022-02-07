//
//  extensions.swift
//  PhotoEditorApp
//
//  Created by 吉郷景虎 on 2020/08/11.
//  Copyright © 2020 Kagetora Yoshigo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func compressed() -> UIImage? {
        
        var compressedImage = UIImage()
        
        if let imageData = self.pngData() {
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 200
            ] as CFDictionary
            
            imageData.withUnsafeBytes { ptr in
                guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count) {
                    let source = CGImageSourceCreateWithData(cfData, nil)!
                    let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                    compressedImage = UIImage(cgImage: imageReference)
                }
            }
        }
        return compressedImage
    }
    
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
