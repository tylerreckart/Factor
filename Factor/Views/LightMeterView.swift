//
//  LightMeterView.swift
//  Factor
//
//  Created by Tyler Reckart on 5/5/25.
//  Refactored on 5/5/25 for Modern UI, Calc Accuracy, Shutter Snapping
//

import SwiftUI
import AVFoundation

struct LightMeterView: View {
    @StateObject private var meterEngine = LightMeterEngine()

    // Target Settings (Selected by User)
    // Initialize using the GLOBAL constants directly
    @State private var targetISO: Float = availableISOs.contains(100) ? 100 : availableISOs.first ?? 100
    @State private var targetAperture: Double = f_stops.contains(8.0) ? 8.0 : f_stops.first ?? 4.0

    // State for Captured Reading Values
    @State private var isReadingCaptured: Bool = false
    @State private var capturedShutterSpeed: Double = 0 // Stores the *snapped* standard shutter speed
    @State private var capturedRawShutterSpeed: Double = 0 // Stores the raw calculated shutter speed
    @State private var capturedISO: Float = 0 // Stores the target ISO at time of capture
    @State private var capturedAperture: Float = 0 // Stores the target Aperture at time of capture
    @State private var capturedSceneEV: Double = 0 // Stores the calculated EV of the scene at capture

    // NOTE: Removed the redundant instance properties for availableISOs and availableApertures.
    // We will use the global constants directly (availableISOs, f_stops).

    var body: some View {
        VStack(spacing: 0) {
            // --- Camera Preview Area (Takes up available space) ---
            ZStack {
                CameraPreviewView(session: meterEngine.captureSession)
                    .ignoresSafeArea(.all) // Extend under status/nav bars and home indicator
                    .opacity(meterEngine.isReady ? 1.0 : 0.3)
                    .animation(.easeInOut, value: meterEngine.isReady)
                    .accessibilityHidden(true) // Hide from accessibility as it's visual feedback
                
                VStack { // Use a VStack to push the gradient to the bottom
                    Spacer() // Pushes the gradient down
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black]), // Fade from transparent to black
                        startPoint: .top,    // Start transparent at the top of the gradient frame
                        endPoint: .bottom    // End black at the bottom of the gradient frame
                    )
                    .frame(height: 120) // Adjust height for desired fade length (e.g., 120 points)
                    .allowsHitTesting(false) // Ensures the gradient doesn't block interactions
                }
                .ignoresSafeArea(.all)

                // --- Overlays ---
                if !meterEngine.isReady {
                    // Loading Indicator
                    VStack {
                        ProgressView().scaleEffect(1.5).tint(.white)
                        Text("Starting Camera...")
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.top, 10)
                            .shadow(radius: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.6))
                    .transition(.opacity)
                }
            }
            .layoutPriority(1) // Give preview more space if needed

            // --- Controls and Display Section ---
            controlsAndDisplaySection
                .background(.regularMaterial) // Use material for modern look
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal)
                .offset(y: -30)
                .edgesIgnoringSafeArea(.bottom)

        }
        .navigationTitle("Light Meter")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.black) // Ensure background is black if preview doesn't fill
        .edgesIgnoringSafeArea(.bottom) // Allow controls to go near bottom edge
        .onAppear {
            print("LightMeterView appeared. Starting session.")
            isReadingCaptured = false // Reset capture state
            meterEngine.startSession()
        }
        .onDisappear {
            print("LightMeterView disappeared. Stopping session.")
            meterEngine.stopSession()
        }
        // Use specific animations for clarity
        .animation(.easeInOut(duration: 0.3), value: isReadingCaptured)
        .animation(.easeInOut(duration: 0.3), value: meterEngine.isReady)
    }

    // --- Controls View Builder ---
    @ViewBuilder
    private var controlsAndDisplaySection: some View {
        VStack(spacing: 10) { // Adjust spacing
            // --- Captured Reading Display ---
            capturedReadingView
                .padding(.top, 15)

            Divider().padding(.horizontal)

            // --- Target Selection Area ---
            targetSelectionPickers
            
            VStack {
                Spacer()
                Button {
                    captureReading()
                } label: {
                    Text("Capture")
                        .font(.title2)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(meterEngine.isReady ? Color("AccentColor") : Color(.systemGray))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .disabled(!meterEngine.isReady)
                .padding(.bottom, 20)
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                .accessibilityHint(isReadingCaptured ? "Tap to take a new light measurement" : "Tap to measure the current light")
            }
        }
    }

    // --- Captured Reading Subview ---
    @ViewBuilder
    private var capturedReadingView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Captured Scene:")
                .font(.caption).textCase(.uppercase)
                .foregroundColor(.secondary)
            
            HStack(spacing: 0) { // Use spacing 0 and Spacer for equal distribution
                MeterValueView(label: "Shutter", value: formatShutterSpeed(capturedShutterSpeed))
                Spacer()
                MeterValueView(label: "Aperture", value: formatAperture(capturedAperture))
                Spacer()
                MeterValueView(label: "ISO", value: formatISO(capturedISO))
            }
        }.padding(.horizontal)
    }

    // --- Target Pickers Subview ----
    @ViewBuilder
    private var targetSelectionPickers: some View {
        VStack(spacing: 12) {
             // Target ISO Picker
             HStack { // Use HStack to place label and picker side-by-side
                 Text("Target ISO:")
                     .font(.callout).foregroundColor(.secondary) // Adjusted font slightly
                 Spacer() // Push picker to the right
                 Picker("Target ISO", selection: $targetISO) {
                     // Use the GLOBAL availableISOs constant here
                     ForEach(availableISOs, id: \.self) { isoValue in
                         Text(formatISO(isoValue)).tag(isoValue)
                     }
                 }
                 .pickerStyle(.menu) // Changed to dropdown/menu style
                 .tint(.primary) // Optional: adjust tint if needed
             }
             .padding(.horizontal) // Apply padding to the HStack

             // Target Aperture Picker
             HStack { // Use HStack to place label and picker side-by-side
                 Text("Target Aperture:")
                     .font(.callout).foregroundColor(.secondary) // Adjusted font slightly
                 Spacer() // Push picker to the right
                 Picker("Target Aperture", selection: $targetAperture) {
                     // Use the GLOBAL f_stops constant here
                     ForEach(f_stops, id: \.self) { fStop in
                         Text(formatAperture(Float(fStop))).tag(fStop)
                     }
                 }
                 .pickerStyle(.menu) // Changed to dropdown/menu style
                 .tint(.primary) // Optional: adjust tint if needed
             }
             .padding(.horizontal) // Apply padding to the HStack
        }
    }

    // --- Core Logic Functions ---

    /// Captures the current light reading and calculates the scene EV.
    func captureReading() {
        guard meterEngine.isReady, meterEngine.shutterSpeed > 0 else {
            print("Factor_Debug: Capture failed - meter engine not ready or shutter speed invalid.")
            // Optionally provide user feedback (e.g., subtle shake animation)
            return
        }

        let measuredShutter = meterEngine.shutterSpeed
        // Prefer measured ISO if valid, otherwise use the currently selected target ISO as fallback
        let measuredOrTargetISO = meterEngine.iso > 0 ? meterEngine.iso : targetISO
        // We always use the target aperture for the EV calculation fallback and suggestion calc,
        // as measured aperture from device might be fixed or unavailable.
        let apertureToUse = Float(targetAperture)

        var calculatedSceneEV: Double = 0

        // --- Determine Scene EV ---
        // Priority 1: Use EV calculated by the engine if it had valid Aperture, ISO, Shutter
        if meterEngine.calculatedEV != 0 {
            calculatedSceneEV = meterEngine.calculatedEV
            print("Factor_Debug: Using engine's calculated EV: \(calculatedSceneEV)")
        }
        // Priority 2: Calculate EV using measured shutter, measured/target ISO, and *target* aperture
        else if measuredShutter > 0 && measuredOrTargetISO > 0 && apertureToUse > 0 {
            // EV = log2(N^2 / t) - log2(S / 100)
            let evPart1 = log2(Double(apertureToUse * apertureToUse) / measuredShutter)
            let evPart2 = log2(Double(measuredOrTargetISO / 100.0))
            calculatedSceneEV = evPart1 - evPart2
             // Validate result
             if calculatedSceneEV.isNaN || calculatedSceneEV.isInfinite {
                 calculatedSceneEV = 0 // Mark as invalid
                 print("Factor_Debug: Fallback EV calculation resulted in NaN or Infinite.")
             } else {
                print("Factor_Debug: Engine EV unavailable. Calculated fallback EV: \(calculatedSceneEV)")
             }
        } else {
            print("Factor_Debug: Cannot calculate EV - insufficient data (S=\(measuredShutter), I=\(measuredOrTargetISO), A=\(apertureToUse)).")
        }

        // --- Store Captured State ---
        if calculatedSceneEV != 0 {
            // Calculate the initial suggested shutter based on the *scene EV* and current target settings
            let suggestedShutterRaw = calculateSuggestedShutter(ev: calculatedSceneEV, targetISO: targetISO, aperture: apertureToUse)
             // Use the GLOBAL standard_shutter_speeds constant here
            let nearestStandardShutter = closestValue(standard_shutter_speeds, suggestedShutterRaw)

            // Update State
            capturedShutterSpeed = nearestStandardShutter // Store the snapped value
            capturedRawShutterSpeed = suggestedShutterRaw // Store the raw value too
            capturedISO = targetISO             // Store the target ISO at capture time
            capturedAperture = apertureToUse    // Store the target Aperture at capture time
            capturedSceneEV = calculatedSceneEV // Store the calculated scene EV

            isReadingCaptured = true
            print("Factor_Debug: Reading captured. EV=\(capturedSceneEV), Target ISO=\(capturedISO), Target A=\(capturedAperture), Suggested S=\(nearestStandardShutter) (Raw: \(suggestedShutterRaw))")
        } else {
            // Failed to get a valid EV reading
            isReadingCaptured = false
            // Reset captured values
            capturedShutterSpeed = 0
            capturedRawShutterSpeed = 0
            capturedISO = 0
            capturedAperture = 0
            capturedSceneEV = 0
            print("Factor_Debug: Failed to capture a valid reading.")
            // Optionally provide user feedback here
        }
    }

    /// Calculates a suggested shutter speed based on a given EV, target ISO, and target Aperture.
    func calculateSuggestedShutter(ev: Double, targetISO: Float, aperture: Float) -> Double {
         guard aperture > 0, targetISO > 0, ev != 0 else { return 0 }

         // Formula derived from EV: t = (N^2 * 100) / (2^EV * S)
         // Using logs: log2(t) = log2(N^2) - EV - log2(S / 100)
         let log2N2 = log2(Double(aperture * aperture))
         let log2S100 = log2(Double(targetISO / 100.0))
         let log2t = log2N2 - ev - log2S100
         let t = pow(2.0, log2t) // t = 2^log2(t)

         // Return 0 if calculation results in invalid numbers
         return (t.isNaN || t.isInfinite) ? 0 : t
    }

    // --- Formatting Helpers ---

    /// Formats shutter speed, prioritizing fractions for < 1s.
    /// `forceFraction`: if true, always formats < 1s as fraction even if it's e.g. 0.4s
    func formatShutterSpeed(_ speed: Double, forceFraction: Bool = false) -> String {
        if speed <= 0 || speed.isNaN || speed.isInfinite { return "---" }

        // Check if the speed is very close to one of the GLOBAL standard speeds for precise formatting
        for standardSpeed in standard_shutter_speeds {
            if abs(speed - standardSpeed) < 0.0001 { // Tolerance for floating point comparison
                 if standardSpeed >= 1.0 {
                    // Format whole seconds without decimal places if possible
                    if standardSpeed.truncatingRemainder(dividingBy: 1) == 0 {
                        return String(format: "%.0f s", standardSpeed)
                    } else {
                        return String(format: "%.1f s", standardSpeed) // Use decimal if needed (e.g., 1.5s if added)
                    }
                 } else {
                     let fraction = Int(round(1.0 / standardSpeed))
                     return fraction > 0 ? "1/\(fraction)" : String(format: "%.3f s", speed) // Fallback if fraction is 0
                 }
            }
        }

        // Fallback for non-standard speeds or if precision check fails
        if speed >= 1.0 || (speed >= 0.35 && !forceFraction) { // Show decimals for speeds >= ~1/3s unless forced
             return String(format: "%.1f s", speed) // Use one decimal place for >= 0.35s
        } else {
             let fraction = Int(round(1.0 / speed))
             return fraction > 0 ? "1/\(fraction)" : "---" // Format as fraction
        }
    }

    /// Formats aperture value.
    func formatAperture(_ aperture: Float) -> String {
        if aperture <= 0 || aperture.isNaN || aperture.isInfinite { return "f/--" }
        // Check if it's a whole number
        if aperture.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "f/%.0f", aperture)
        } else {
            return String(format: "f/%.1f", aperture)
        }
    }

    /// Formats ISO value.
     func formatISO(_ iso: Float) -> String {
         if iso <= 0 || iso.isNaN || iso.isInfinite { return "---" }
         return String(format: "%.0f", iso)
     }

    /// Formats Exposure Value (EV).
    func formatEV(_ ev: Double) -> String {
        // Consider EV 0 as potentially valid, but NaN/Infinite as invalid.
        if ev.isNaN || ev.isInfinite { return "--" }
        return String(format: "%+.1f", ev) // Always show sign (+/-)
    }
}

// --- Reusable Meter Value Display Component ---
struct MeterValueView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
             Text(label).font(.caption).foregroundColor(.secondary)
             Text(value)
                .font(.system(.headline, design: .rounded).weight(.medium))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6) // Allow shrinking
                .frame(minWidth: 55) // Ensure minimum width
        }
    }
}
