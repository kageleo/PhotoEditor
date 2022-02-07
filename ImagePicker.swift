//
//  ImagePicker.swift
//  PhotoEditorApp
//
//  Created by 吉郷景虎 on 2020/08/11.
//  Copyright © 2020 Kagetora Yoshigo. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @ObservedObject var imageController: ImageController
    
    @Binding var showImagePicker: Bool
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ imagePicker: ImagePicker) {
            self.parent = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                print("No image found")
                return
            }
            parent.imageController.originalImage = image.upOrientationImage()
            parent.showImagePicker = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showImagePicker = false
        }
    }
    
}
