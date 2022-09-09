//
//  CameraCaptureView.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/9/22.
//

import UIKit
import SwiftUI

struct CameraCaptureView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?

    @Environment(\.presentationMode) var isPresented

    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let cameraViewController = UIImagePickerController()
        cameraViewController.delegate = context.coordinator
        cameraViewController.sourceType = .camera
        cameraViewController.allowsEditing = false
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var picker: CameraCaptureView
        
        init(picker: CameraCaptureView) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let capturedImage = info[.originalImage] as? UIImage
            self.picker.capturedImage = capturedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
}
