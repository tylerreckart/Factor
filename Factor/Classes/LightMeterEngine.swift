//
//  LightMeterEngine.swift
//  Factor
//
//  Created by Tyler Reckart on 5/5/25.
//

import AVFoundation
import Combine
import SwiftUI

class LightMeterEngine: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {

    @Published var isReady: Bool = false

    @Published var shutterSpeed: Double = 0
    @Published var iso: Float = 0
    @Published var aperture: Float = 0
    @Published var calculatedEV: Double = 0 // Exposure Value

    public var captureSession: AVCaptureSession?
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer? // For displaying preview
    public var captureDevice: AVCaptureDevice?
    
    // --- Observer state ---
    private var isObservingExposureDuration = false
    private var isObservingISO = false
    private var isObservingLensAperture = false

    override init() {
        super.init()
        checkPermissionsAndSetup()
    }

    private func checkPermissionsAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupCaptureSession()
                    }
                }
            }
        default:
            // Handle denied or restricted state
            print("Camera access denied or restricted.")
            return
        }
    }

    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let session = captureSession else { return }

        session.sessionPreset = .photo // Use a preset appropriate for metering

        // Get the default back camera
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Failed to get camera device.")
            return
        }
        self.captureDevice = device

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }

            // --- Method 1: Observe device properties (Simpler for basic values) ---
            // Start observing changes to exposure properties AFTER session starts running
            // See startSession() method below.

            // --- Method 2: Use Video Data Output (More complex, allows analyzing frames) ---
            // let videoOutput = AVCaptureVideoDataOutput()
            // videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            // if session.canAddOutput(videoOutput) {
            //     session.addOutput(videoOutput)
            // }
            // -----------------------------------------------------------------------


            // Setup preview layer (optional but recommended for user feedback)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer?.videoGravity = .resizeAspectFill


        } catch {
            print("Error setting up camera input: \(error)")
            return
        }
    }

    // Call this from your SwiftUI view's onAppear
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
             guard let self = self, let session = self.captureSession, !session.isRunning else { return }

             // --- Ensure captureDevice exists before adding observers ---
             guard let device = self.captureDevice else {
                print("Error: Capture device is nil, cannot add observers.")
                // Start session even if observers can't be added, preview might still work
                session.startRunning()
                return
             }
             // ---------------------------------------------------------

             session.startRunning()

             // --- Add Observers After Starting & Check Success ---
             // Using try? to safely attempt adding observers. KVO addObserver doesn't throw Swift errors,
             // but it's good practice to be cautious with device availability.
             // Ensure these are added *after* startRunning and only if device exists.

             device.addObserver(self, forKeyPath: "exposureDuration", options: .new, context: nil)
             self.isObservingExposureDuration = true // Assume success if no crash

             device.addObserver(self, forKeyPath: "ISO", options: .new, context: nil)
             self.isObservingISO = true // Assume success

             device.addObserver(self, forKeyPath: "lensAperture", options: .new, context: nil)
             self.isObservingLensAperture = true // Assume success
             // --------------------------------------------------
        }
    }

    func stopSession() {
        // --- Remove Observers Before Stopping ONLY IF Added ---
        // Check flags before removing each observer
         if let device = captureDevice { // Ensure device exists
             if isObservingExposureDuration {
                device.removeObserver(self, forKeyPath: "exposureDuration")
                isObservingExposureDuration = false
             }
             if isObservingISO {
                device.removeObserver(self, forKeyPath: "ISO")
                isObservingISO = false
             }
             if isObservingLensAperture {
                device.removeObserver(self, forKeyPath: "lensAperture")
                isObservingLensAperture = false
             }
         }
         // --------------------------------------------------

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
             guard let self = self, let session = self.captureSession, session.isRunning else { return }
             session.stopRunning()
        }
    }

     // KVO method to handle property changes
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("Factor_Debug: observeValue called for keyPath: \(keyPath ?? "nil")") // DEBUG

        guard let device = object as? AVCaptureDevice else {
           print("Factor_Debug: observeValue guard failed - object is not AVCaptureDevice") // DEBUG
           return
        }

        // Read current values immediately off the KVO thread
        var localShutter = self.shutterSpeed
        var localISO = self.iso
        var localAperture = self.aperture // Read current state
        var valueChanged = false

        if keyPath == "exposureDuration" {
            let durationSeconds = CMTimeGetSeconds(device.exposureDuration)
            print("Factor_Debug: exposureDuration received. Value: \(durationSeconds)") // DEBUG
            // Check against current @Published value for change detection might be better here
            if !durationSeconds.isNaN && !durationSeconds.isInfinite && self.shutterSpeed != durationSeconds {
                 localShutter = durationSeconds
                 valueChanged = true
                 print("Factor_Debug: exposureDuration is NEW.") // DEBUG
            }
        } else if keyPath == "ISO" {
            let newISO = device.iso
             print("Factor_Debug: ISO received. Value: \(newISO)") // DEBUG
            if !newISO.isNaN && !newISO.isInfinite && self.iso != newISO {
                localISO = newISO
                valueChanged = true
                print("Factor_Debug: ISO is NEW.") // DEBUG
            }
        } else if keyPath == "lensAperture" {
             let newAperture = device.lensAperture
             print("Factor_Debug: lensAperture received. Value: \(newAperture)") // DEBUG
             // We might receive 0 or a fixed value. Update only if it's > 0 and different.
             if !newAperture.isNaN && !newAperture.isInfinite && newAperture > 0 && self.aperture != newAperture {
                 localAperture = newAperture
                 valueChanged = true // Only flag change if it's a valid, new aperture
                 print("Factor_Debug: lensAperture is NEW and VALID (>0).") // DEBUG
             } else if newAperture <= 0 && self.aperture != 0 {
                 // If device reports 0 but we had a valid aperture before, maybe don't update?
                 // Or update localAperture to reflect the 0? Let's reflect it locally.
                 localAperture = newAperture // Reflect the 0 or invalid value locally
                 valueChanged = true // Consider this a change
                 print("Factor_Debug: lensAperture is NEW but INVALID (<=0).") // DEBUG
             }
        }

        // --- Determine Readiness based ONLY on Shutter and ISO ---
        let partialReady = localShutter > 0 && localISO > 0
        print("Factor_Debug: Partial Readiness check (Shutter & ISO > 0): \(partialReady)") // DEBUG

        // Dispatch updates to main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // --- Update @Published properties ---
            if valueChanged {
                self.shutterSpeed = localShutter
                self.iso = localISO
                // Update aperture regardless of validity now, rely on checks below
                self.aperture = localAperture
                print("Factor_Debug: Updated @Published vars on main thread: S=\(self.shutterSpeed), I=\(self.iso), A=\(self.aperture)") // DEBUG
            }

            // --- Set isReady based on Shutter & ISO ---
            // Set ready as soon as Shutter and ISO are valid, even if aperture isn't yet.
            // The UI can then decide what to display based on aperture's validity.
            if partialReady && !self.isReady {
                self.isReady = true
                print("Factor_Debug: Setting isReady = true on main thread (Shutter & ISO OK).") // DEBUG
            }

            // --- Calculate EV only if ALL components are valid ---
            // Check the updated @Published properties on the main thread
            if self.shutterSpeed > 0 && self.iso > 0 && self.aperture > 0 {
                 self.calculateEV()
                 print("Factor_Debug: Calculated EV = \(self.calculatedEV)") // DEBUG
            } else if valueChanged { // Reset EV if any component became invalid
                 self.calculatedEV = 0
                 print("Factor_Debug: Reset EV to 0 because a component is invalid.") // DEBUG
            }
        }
    }


     // Function to expose the preview layer to SwiftUI
     func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
         return videoPreviewLayer
     }


    // Calculation for EV
    private func calculateEV() {
        // EV = log2(N^2 / t) - log2(S / 100)
        // Where N = aperture, t = shutter speed (seconds), S = ISO
        let evPart1 = log2(Double(aperture * aperture) / shutterSpeed)
        let evPart2 = log2(Double(iso / 100.0))
        self.calculatedEV = evPart1 - evPart2
    }

    // Calculate suggested shutter speed for a *target* ISO (using current EV)
    func calculateSuggestedShutter(targetISO: Float, targetAperture: Float? = nil) -> Double {
        // Use the currently calculated EV
         let N = targetAperture ?? self.aperture // Use target aperture if provided, else current
         guard N > 0 else { return 0 }

         // EV = log2(N^2 / t) - log2(S / 100)
         // Rearrange for t: log2(t) = log2(N^2) - EV - log2(S / 100)
         let log2t = log2(Double(N * N)) - calculatedEV - log2(Double(targetISO / 100.0))

        // t = 2 ^ log2(t)
        let t = pow(2.0, log2t)
        return t // suggested shutter speed in seconds
    }


    // Deinit to ensure observers are removed if object is destroyed
    deinit {
        if let device = captureDevice {
            if isObservingExposureDuration {
               device.removeObserver(self, forKeyPath: "exposureDuration")
            }
            if isObservingISO {
               device.removeObserver(self, forKeyPath: "ISO")
            }
            if isObservingLensAperture {
               device.removeObserver(self, forKeyPath: "lensAperture")
            }
        }
         if let session = captureSession, session.isRunning {
             session.stopRunning()
         }
       print("LightMeterEngine deinitialized")
   }
}
