//
//  CameraView.swift
//  PhotoEditorApp
//
//  Created by 吉郷景虎 on 2020/08/20.
//  Copyright © 2020 Kagetora Yoshigo. All rights reserved.
//

import Foundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    @ObservedObject var imageController: ImageController
    
    @Binding var showCameraView: Bool
    
    func makeCoordinator() -> CameraView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let cameraViewController = UIImagePickerController()
        cameraViewController.delegate = context.coordinator
        cameraViewController.sourceType = .camera
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        
        init(_ cameraView: CameraView) {
            self.parent = cameraView
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                print("No image found")
                return
            }
            parent.imageController.originalImage = image.upOrientationImage()
            parent.showCameraView = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCameraView = false
        }
    }
}
