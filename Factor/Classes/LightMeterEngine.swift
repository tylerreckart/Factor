//
//  LightMeterEngine.swift
//  Factor
//
//  Created by Tyler Reckart on 5/5/25.
//  Refactored on 5/23/25 for KVO handling and state consistency.
//

import AVFoundation
import Combine
import SwiftUI

class LightMeterEngine: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {

    // MARK: - Published Properties
    @Published var isReady: Bool = false
    @Published var shutterSpeed: Double = 0
    @Published var iso: Float = 0
    @Published var aperture: Float = 0
    @Published var calculatedEV: Double = 0 // Exposure Value

    // MARK: - AVFoundation Components
    public var captureSession: AVCaptureSession?
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    public var captureDevice: AVCaptureDevice?
    
    // MARK: - Internal State
    private var _currentShutterSpeed: Double = 0
    private var _currentISO: Float = 0
    private var _currentAperture: Float = 0 // Store the actual lens aperture from device

    // MARK: - Observer State
    private var isObservingExposureDuration = false
    private var isObservingISO = false
    private var isObservingLensAperture = false

    // MARK: - Debounce Mechanism
    private var debounceTimer: DispatchWorkItem?
    private let debounceInterval: TimeInterval = 0.1 // 100ms debounce

    // MARK: - Initialization
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
                } else {
                    print("Factor_Debug: Camera access not granted.")
                    // Optionally, update a state to inform UI about permission denial
                }
            }
        default:
            print("Factor_Debug: Camera access denied or restricted.")
            // Optionally, update a state to inform UI
            return
        }
    }

    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let session = captureSession else {
            print("Factor_Debug: Failed to create capture session.")
            return
        }

        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Factor_Debug: Failed to get default camera device.")
            return
        }
        self.captureDevice = device

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Factor_Debug: Cannot add input to session.")
                return
            }

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer?.videoGravity = .resizeAspectFill

        } catch {
            print("Factor_Debug: Error setting up camera input: \(error)")
            return
        }
    }

    // MARK: - Session Control
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let session = self.captureSession, !session.isRunning else { return }
            guard let device = self.captureDevice else {
                print("Factor_Debug: Capture device is nil, cannot start session or add observers.")
                return
            }
            
            print("Factor_Debug: Starting capture session...")
            session.startRunning()
            print("Factor_Debug: Capture session started.")

            // Attempt to get initial fixed lens aperture
            // This is important as lensAperture KVO might not fire if it's fixed.
            let initialAperture = device.lensAperture
            if initialAperture > 0 && !initialAperture.isNaN && !initialAperture.isInfinite {
                self._currentAperture = initialAperture
                print("Factor_Debug: Initial lens aperture read: \(initialAperture)")
            } else {
                print("Factor_Debug: Could not read a valid initial lens aperture.")
            }
            
            // Add observers after session is running
            self.addObservers(to: device)
            
            // Initial state update after attempting to read aperture and potentially starting observers
            self.scheduleStateUpdate()
        }
    }

    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let session = self.captureSession, session.isRunning else { return }
            
            print("Factor_Debug: Stopping capture session...")
            // Remove observers before stopping the session
            if let device = self.captureDevice {
                self.removeObservers(from: device)
            }
            
            session.stopRunning()
            print("Factor_Debug: Capture session stopped.")

            // Reset state when session stops
            DispatchQueue.main.async {
                self.isReady = false
                self.calculatedEV = 0
                // Optionally reset shutterSpeed, iso, aperture to 0 if desired
                // self.shutterSpeed = 0
                // self.iso = 0
                // self.aperture = 0 // Or keep last known aperture
            }
        }
    }

    // MARK: - KVO Observation
    private func addObservers(to device: AVCaptureDevice) {
        // Ensure not adding observers multiple times
        if !isObservingExposureDuration {
            device.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureDuration), options: .new, context: nil)
            isObservingExposureDuration = true
            print("Factor_Debug: Added observer for exposureDuration.")
        }
        if !isObservingISO {
            device.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.iso), options: .new, context: nil)
            isObservingISO = true
            print("Factor_Debug: Added observer for ISO.")
        }
        if !isObservingLensAperture {
            // Note: lensAperture is often fixed on iPhones. KVO might not fire often.
            device.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.lensAperture), options: .new, context: nil)
            isObservingLensAperture = true
            print("Factor_Debug: Added observer for lensAperture.")
        }
    }

    private func removeObservers(from device: AVCaptureDevice) {
        if isObservingExposureDuration {
            device.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureDuration), context: nil)
            isObservingExposureDuration = false
            print("Factor_Debug: Removed observer for exposureDuration.")
        }
        if isObservingISO {
            device.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.iso), context: nil)
            isObservingISO = false
            print("Factor_Debug: Removed observer for ISO.")
        }
        if isObservingLensAperture {
            device.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.lensAperture), context: nil)
            isObservingLensAperture = false
            print("Factor_Debug: Removed observer for lensAperture.")
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let device = object as? AVCaptureDevice else {
            print("Factor_Debug: KVO - object is not AVCaptureDevice or is nil.")
            return
        }

        var needsStateUpdate = false

        switch keyPath {
        case #keyPath(AVCaptureDevice.exposureDuration):
            let durationSeconds = CMTimeGetSeconds(device.exposureDuration)
            if !durationSeconds.isNaN && !durationSeconds.isInfinite && durationSeconds > 0 {
                if _currentShutterSpeed != durationSeconds {
                    _currentShutterSpeed = durationSeconds
                    needsStateUpdate = true
                    print("Factor_Debug: KVO - Internal Shutter updated: \(_currentShutterSpeed)")
                }
            }
        case #keyPath(AVCaptureDevice.iso):
            let newISO = device.iso
            if !newISO.isNaN && !newISO.isInfinite && newISO > 0 {
                if _currentISO != newISO {
                    _currentISO = newISO
                    needsStateUpdate = true
                    print("Factor_Debug: KVO - Internal ISO updated: \(_currentISO)")
                }
            }
        case #keyPath(AVCaptureDevice.lensAperture):
            let newAperture = device.lensAperture
            // lensAperture can be fixed, so update if it's valid and different, or if our internal one is still 0
            if !newAperture.isNaN && !newAperture.isInfinite && newAperture > 0 {
                if _currentAperture != newAperture {
                    _currentAperture = newAperture
                    needsStateUpdate = true
                    print("Factor_Debug: KVO - Internal Aperture updated: \(_currentAperture)")
                }
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return // Exit if keyPath is not one we handle
        }

        if needsStateUpdate {
            scheduleStateUpdate()
        }
    }
    
    // MARK: - State Update Logic
    private func scheduleStateUpdate() {
        // Cancel any existing debounced task
        debounceTimer?.cancel()

        // Create a new work item
        let task = DispatchWorkItem { [weak self] in
            self?.processSensorDataAndUpdatePublishedState()
        }
        debounceTimer = task
        
        // Schedule the task
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: task)
    }

    private func processSensorDataAndUpdatePublishedState() {
        // This method is now guaranteed to be called on the main thread due to scheduleStateUpdate
        
        let newShutter = self._currentShutterSpeed
        let newISO = self._currentISO
        let newAperture = self._currentAperture // This should be the actual lens aperture

        // Determine overall readiness
        let allComponentsValid = newShutter > 0 && newISO > 0 && newAperture > 0
        
        // Update @Published properties
        self.shutterSpeed = newShutter
        self.iso = newISO
        self.aperture = newAperture // Publish the actual lens aperture

        if allComponentsValid {
            // Calculate EV using the now consistent internal values
            let evPart1 = log2(Double(newAperture * newAperture) / newShutter)
            let evPart2 = log2(Double(newISO / 100.0))
            let newEV = evPart1 - evPart2

            if !newEV.isNaN && !newEV.isInfinite {
                self.calculatedEV = newEV
            } else {
                self.calculatedEV = 0 // EV calculation resulted in invalid number
            }
            
            if !self.isReady { // Only print if state changes
                 print("Factor_Debug: State Update - Meter is NOW READY. S=\(newShutter), I=\(newISO), A=\(newAperture), EV=\(self.calculatedEV)")
            }
            self.isReady = true
        } else {
            self.calculatedEV = 0
            if self.isReady { // Only print if state changes
                print("Factor_Debug: State Update - Meter is NOT READY. S=\(newShutter), I=\(newISO), A=\(newAperture)")
            }
            self.isReady = false
        }
        
        // More detailed log of published state
        // print("Factor_Debug: Published State: Ready=\(self.isReady), S=\(self.shutterSpeed), I=\(self.iso), A=\(self.aperture), EV=\(self.calculatedEV)")
    }

    // MARK: - Utility Functions
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return videoPreviewLayer
    }

    // MARK: - Deinitialization
    deinit {
        // Cancel any pending debounced task
        debounceTimer?.cancel()
        
        // Ensure observers are removed
        if let device = captureDevice, sessionIsRunning() { // Check if session is running to avoid issues
             // It's safer to remove observers only if the session was running or they were definitely added.
             // The stopSession() method should handle observer removal more reliably.
             // However, as a fallback:
            removeObservers(from: device)
        }
        
        // Ensure session is stopped
        if let session = captureSession, session.isRunning {
            session.stopRunning()
        }
        print("Factor_Debug: LightMeterEngine deinitialized.")
    }
    
    private func sessionIsRunning() -> Bool {
        return captureSession?.isRunning ?? false
    }
}
