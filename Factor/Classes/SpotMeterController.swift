//
//  SpotMeterController.swift
//  Factor
//
//  Created by Tyler Reckart on 9/11/22.
//

import UIKit
import AVFoundation
import SwiftUI

enum CameraControllerError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}

class SpotMeterController: NSObject {
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func prepare(completionHandler: @escaping (Error?) -> Void){
        func createCaptureSession(){
            self.captureSession = AVCaptureSession()
        }
        func configureCaptureDevices() throws {
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
            
            self.frontCamera = camera
            
            try camera?.lockForConfiguration()
            camera?.unlockForConfiguration()
                
        }
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
               
            if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                   
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!)}
                else { throw CameraControllerError.inputsAreInvalid }
                   
            }
            else { throw CameraControllerError.noCamerasAvailable }
               
            captureSession.startRunning()
               
        }
           
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
            }
                
            catch {
                DispatchQueue.main.async{
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
            
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
}

final class SpotMeterViewController: UIViewController {
    let meterController = SpotMeterController()
    var previewView: UIView!
    
    
    override func viewDidLoad() {
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        
        meterController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.meterController.displayPreview(on: self.previewView)
        }
    }
    
    
}

extension SpotMeterViewController : UIViewControllerRepresentable{
    public typealias UIViewControllerType = SpotMeterViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<SpotMeterViewController>) -> SpotMeterViewController {
        return SpotMeterViewController()
    }
    
    public func updateUIViewController(_ uiViewController: SpotMeterViewController, context: UIViewControllerRepresentableContext<SpotMeterViewController>) {
    }
}
