//
//  FilterFactor.swift
//  Factor
//
//  Created by Tyler Reckart on 8/17/22.
//
import SwiftUI

struct FilterFactor: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var open: Bool
    
    @State private var priorityMode: PriorityMode = .aperture

    @State private var shutterSpeed: String = ""
    @State private var aperture: String = ""
    @State private var fStopReduction: Double = 1
    @State private var compensatedShutter: String = ""
    @State private var compensatedAperture: Double = 0
    @State private var selected: Double = 1
    @State private var calculatedFactor: Bool = false
    @State private var showingHistorySheet: Bool = false
    
    @State private var presentError: Bool = false

    var body: some View {
        Dialog(
            content: {
                FilterForm(
                    priorityMode: $priorityMode,
                    shutterSpeed: $shutterSpeed,
                    aperture: $aperture,
                    calculatedFactor: $calculatedFactor,
                    calculate: calculate,
                    reset: reset,
                    selected: $selected
                )
            },
            calculatedContent: {
                if (self.calculatedFactor && compensatedShutter.count > 0) {
                    CalculatedResultCard(
                        label: "Adjusted Shutter Speed",
                        icon: "clock.circle.fill",
                        result: "\(compensatedShutter) seconds",
                        background: Color(.systemPurple)
                    )
                } else {
                    CalculatedResultCard(
                        label: "Adjusted Aperture",
                        icon: "f.cursive.circle.fill",
                        result: "f/\(compensatedAperture.clean)",
                        background: Color(.systemGreen)
                    )
                }
            },
            open: $open,
            calculated: $calculatedFactor
        )
    }
    
    private func calculate() {
        do {
            if priorityMode == .aperture {
                let adjustment = pow(2, selected)
                let as_double = convertShutterSpeedStrToDouble(shutterSpeed)
                let adjusted_speed = as_double * adjustment
                
                if (adjusted_speed >= 1) {
                    compensatedShutter = String(Int(adjusted_speed))
                } else {
                    compensatedShutter = convertDecimalShutterSpeedToFraction(adjusted_speed)
                }
            }
            
            if priorityMode == .shutter {
                let as_double = Double(aperture) ?? 0
                let closest_defined_aperture = closestValue(f_stops, as_double)
                let index = f_stops.firstIndex(of: closest_defined_aperture)

                if (index != nil) {
                    let targetIndex = index! + Int(selected)
                    let adjusted_aperture = f_stops[targetIndex]
                    compensatedAperture = adjusted_aperture
                }
            }
            
            calculatedFactor = true
        }
    }
    
    private func reset() {
        calculatedFactor = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            compensatedAperture = 0
            compensatedShutter = ""
        }
    }
}
