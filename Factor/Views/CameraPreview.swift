//
//  CameraPreview.swift
//  Factor
//
//  Created by Tyler Reckart on 5/5/25.
//

import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    // Use a binding to ensure the session changes are reflected if needed,
    // though simply passing it should work if it's created early.
    let session: AVCaptureSession?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black

        guard let validSession = session else {
            print("CameraPreviewView: Session is nil")
            return view
        }

        // Ensure layer operations are on the main thread
        DispatchQueue.main.async {
            let previewLayer = AVCaptureVideoPreviewLayer(session: validSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds // Set initial frame
            view.layer.addSublayer(previewLayer)
            context.coordinator.previewLayer = previewLayer

            // It might be better to set the frame initially and then update in updateUIView
            // view.setNeedsLayout() // layoutIfNeeded might not be necessary here
            // view.layoutIfNeeded()
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Ensure frame updates occur on the main thread
        DispatchQueue.main.async {
            guard let previewLayer = context.coordinator.previewLayer else { return }
            previewLayer.frame = uiView.bounds

            // Check if session needs updating (less likely needed with @StateObject)
            if previewLayer.session != session {
                previewLayer.session = session
            }
            // uiView.layer.layoutIfNeeded() // Often not needed if frame setting is direct
            print("CameraPreviewView updated with bounds: \(uiView.bounds)")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}
