//
//  LightMeterView.swift
//  Factor
//
//  Created by Tyler Reckart on 5/5/25.
//  Refactored on 5/5/25 for Modern UI, Calc Accuracy, Shutter Snapping
//  Further refined on 5/23/25 for app aesthetic consistency and usability
//

import SwiftUI
import AVFoundation

struct LightMeterView: View {
    @StateObject private var meterEngine = LightMeterEngine()
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    // Target Settings (Selected by User)
    @State private var targetISO: Float = availableISOs.contains(100) ? 100 : availableISOs.first ?? 100
    @State private var targetAperture: Double = f_stops.contains(8.0) ? 8.0 : f_stops.first ?? 4.0

    // State for Captured Reading Values
    @State private var isReadingCaptured: Bool = false
    @State private var capturedShutterSpeed: Double = 0
    @State private var capturedRawShutterSpeed: Double = 0
    @State private var capturedISO: Float = 0
    @State private var capturedAperture: Float = 0
    @State private var capturedSceneEV: Double = 0

    var body: some View {
        NavigationView {
            ZStack {
                CameraPreviewView(session: meterEngine.captureSession)
                    .ignoresSafeArea(.all)
                    .opacity(meterEngine.isReady ? 1.0 : 0.3)
                    .animation(.easeInOut, value: meterEngine.isReady)
                    .accessibilityHidden(true)
                
                if !meterEngine.isReady {
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
                
                if meterEngine.isReady {
                    VStack {
                        Spacer()
                        controlsAndDisplaySection
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            .offset(y: -30)
                            .shadow(color: meterEngine.isReady ? .black.opacity(0.1) : .clear, radius: 8, x: 0, y: 4)
                            .animation(.easeInOut, value: meterEngine.isReady)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                print("LightMeterView appeared. Starting session.")
                isReadingCaptured = false
                meterEngine.startSession()
            }
            .onDisappear {
                print("LightMeterView disappeared. Stopping session.")
                meterEngine.stopSession()
            }
            .animation(.easeInOut(duration: 0.3), value: isReadingCaptured)
            .animation(.easeInOut(duration: 0.3), value: meterEngine.isReady)
        }
        .navigationViewStyle(.stack) // Ensures proper display in sheet
    }

    @ViewBuilder
    private var controlsAndDisplaySection: some View {
        VStack(spacing: 18) { // Consistent spacing
            capturedReadingView
                .padding(.top, 20) // More top padding inside the card

            Divider().padding(.horizontal)

            targetSelectionPickers.padding(.bottom)

            Button {
                captureReading()
            } label: {
                Text("Capture")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(meterEngine.isReady ? userAccentColor : Color(.systemGray3))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: meterEngine.isReady ? userAccentColor.opacity(0.4) : .clear, radius: 8, x: 0, y: 4)
            }
            .disabled(!meterEngine.isReady)
            .padding(.horizontal)
            .accessibilityHint(isReadingCaptured ? "Tap to take a new light measurement" : "Tap to measure the current light")
        }
        .padding(.bottom, 20) // Bottom padding for content within the controls section
    }

    @ViewBuilder
    private var capturedReadingView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(isReadingCaptured ? "Last Reading" : "Meter Ready")
                .font(.subheadline.weight(.semibold))
                .textCase(.uppercase)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if isReadingCaptured {
                HStack {
                    MeterValueView(label: "Shutter", value: formatShutterSpeed(capturedShutterSpeed))
                    Spacer()
                    MeterValueView(label: "Aperture", value: formatAperture(capturedAperture))
                    Spacer()
                    MeterValueView(label: "ISO", value: formatISO(capturedISO))
                }
                .padding(.horizontal)
                .padding(.top, 4)

                HStack { // Display EV
                    Spacer()
                    Text("Scene EV: \(formatEV(capturedSceneEV))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.top, 6)

            } else {
                HStack {
                    Spacer()
                    Text("Point camera and tap Capture.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 20) // Give it some vertical space to fill
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private var targetSelectionPickers: some View {
        VStack(spacing: 18) { // Consistent spacing
             HStack {
                 Text("Target ISO") // Simplified label
                     .font(.callout)
                 Spacer()
                 Picker("Target ISO", selection: $targetISO) {
                     ForEach(availableISOs, id: \.self) { isoValue in
                         Text(formatISO(isoValue)).tag(isoValue)
                     }
                 }
                 .pickerStyle(.menu)
                 .tint(userAccentColor) // Use accent color
             }
             .padding(.horizontal)

             HStack {
                 Text("Target Aperture") // Simplified label
                     .font(.callout)
                 Spacer()
                 Picker("Target Aperture", selection: $targetAperture) {
                     ForEach(f_stops, id: \.self) { fStop in
                         Text(formatAperture(Float(fStop))).tag(fStop)
                     }
                 }
                 .pickerStyle(.menu)
                 .tint(userAccentColor) // Use accent color
             }
             .padding(.horizontal)
        }
    }

    // --- Core Logic Functions ---
    // (No changes to captureReading or calculateSuggestedShutter)
    func captureReading() {
        guard meterEngine.isReady, meterEngine.shutterSpeed > 0 else {
            print("Factor_Debug: Capture failed - meter engine not ready or shutter speed invalid.")
            return
        }

        let measuredShutter = meterEngine.shutterSpeed
        let measuredOrTargetISO = meterEngine.iso > 0 ? meterEngine.iso : targetISO
        let apertureToUse = Float(targetAperture)
        var calculatedSceneEV: Double = 0

        if meterEngine.calculatedEV != 0 {
            calculatedSceneEV = meterEngine.calculatedEV
            print("Factor_Debug: Using engine's calculated EV: \(calculatedSceneEV)")
        }
        else if measuredShutter > 0 && measuredOrTargetISO > 0 && apertureToUse > 0 {
            let evPart1 = log2(Double(apertureToUse * apertureToUse) / measuredShutter)
            let evPart2 = log2(Double(measuredOrTargetISO / 100.0))
            calculatedSceneEV = evPart1 - evPart2
             if calculatedSceneEV.isNaN || calculatedSceneEV.isInfinite {
                 calculatedSceneEV = 0
                 print("Factor_Debug: Fallback EV calculation resulted in NaN or Infinite.")
             } else {
                print("Factor_Debug: Engine EV unavailable. Calculated fallback EV: \(calculatedSceneEV)")
             }
        } else {
            print("Factor_Debug: Cannot calculate EV - insufficient data (S=\(measuredShutter), I=\(measuredOrTargetISO), A=\(apertureToUse)).")
        }

        if calculatedSceneEV != 0 {
            let suggestedShutterRaw = calculateSuggestedShutter(ev: calculatedSceneEV, targetISO: targetISO, aperture: apertureToUse)
            let nearestStandardShutter = closestValue(standard_shutter_speeds, suggestedShutterRaw)

            capturedShutterSpeed = nearestStandardShutter
            capturedRawShutterSpeed = suggestedShutterRaw
            capturedISO = targetISO
            capturedAperture = apertureToUse
            capturedSceneEV = calculatedSceneEV
            isReadingCaptured = true
            print("Factor_Debug: Reading captured. EV=\(capturedSceneEV), Target ISO=\(capturedISO), Target A=\(capturedAperture), Suggested S=\(nearestStandardShutter) (Raw: \(suggestedShutterRaw))")
        } else {
            isReadingCaptured = false
            capturedShutterSpeed = 0
            capturedRawShutterSpeed = 0
            capturedISO = 0
            capturedAperture = 0
            capturedSceneEV = 0
            print("Factor_Debug: Failed to capture a valid reading.")
        }
    }

    func calculateSuggestedShutter(ev: Double, targetISO: Float, aperture: Float) -> Double {
         guard aperture > 0, targetISO > 0, ev != 0 else { return 0 }
         let log2N2 = log2(Double(aperture * aperture))
         let log2S100 = log2(Double(targetISO / 100.0))
         let log2t = log2N2 - ev - log2S100
         let t = pow(2.0, log2t)
         return (t.isNaN || t.isInfinite) ? 0 : t
    }

    // --- Formatting Helpers ---
    // (No changes to formatting helpers)
    func formatShutterSpeed(_ speed: Double, forceFraction: Bool = false) -> String {
        if speed <= 0 || speed.isNaN || speed.isInfinite { return "---" }
        for standardSpeed in standard_shutter_speeds {
            if abs(speed - standardSpeed) < 0.0001 {
                 if standardSpeed >= 1.0 {
                    if standardSpeed.truncatingRemainder(dividingBy: 1) == 0 {
                        return String(format: "%.0f s", standardSpeed)
                    } else {
                        return String(format: "%.1f s", standardSpeed)
                    }
                 } else {
                     let fraction = Int(round(1.0 / standardSpeed))
                     return fraction > 0 ? "1/\(fraction)" : String(format: "%.3f s", speed)
                 }
            }
        }
        if speed >= 1.0 || (speed >= 0.35 && !forceFraction) {
             return String(format: "%.1f s", speed)
        } else {
             let fraction = Int(round(1.0 / speed))
             return fraction > 0 ? "1/\(fraction)" : "---"
        }
    }

    func formatAperture(_ aperture: Float) -> String {
        if aperture <= 0 || aperture.isNaN || aperture.isInfinite { return "f/--" }
        if aperture.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "f/%.0f", aperture)
        } else {
            return String(format: "f/%.1f", aperture)
        }
    }

     func formatISO(_ iso: Float) -> String {
         if iso <= 0 || iso.isNaN || iso.isInfinite { return "---" }
         return String(format: "%.0f", iso)
     }

    func formatEV(_ ev: Double) -> String {
        if ev.isNaN || ev.isInfinite { return "--" }
        return String(format: "%+.1f", ev)
    }
}

// --- Reusable Meter Value Display Component (Updated) ---
struct MeterValueView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .center, spacing: 4) { // Slightly more spacing
             Text(label.uppercased()) // Uppercase for consistency
                .font(.caption.weight(.medium)) // Bolder caption
                .foregroundColor(.secondary)
             Text(value)
                .font(.system(.title2, design: .rounded).weight(.semibold)) // Larger, bolder value
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7) // Allow shrinking, ensure it's effective
                .frame(minWidth: 80) // Increased minWidth for better display
        }
    }
}
