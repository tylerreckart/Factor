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
                CalculatedResultCard(
                    label: compensatedShutter.count > 0 ? "Adjusted shutter speed (seconds)" : "Adjusted aperture",
                    icon: compensatedShutter.count > 0 ? "clock.circle.fill" : "f.cursive.circle.fill",
                    result: compensatedShutter.count > 0 ? "\(compensatedShutter) seconds" : "f/\(compensatedAperture.clean)",
                    background: compensatedShutter.count > 0 ? Color(.systemPurple) : Color(.systemGreen)
                )
            },
            open: $open,
            calculated: $calculatedFactor
        )
    }
    
    private func calculate() {
        let adjustment = pow(2, selected)

        do {
            if priorityMode == .aperture {
                let as_double = convertShutterSpeedStrToDouble(shutterSpeed)
                let adjusted_speed = as_double * adjustment
                
                if (adjusted_speed >= 1) {
                    compensatedShutter = String(adjusted_speed.clean)
                } else {
                    compensatedShutter = convertDecimalShutterSpeedToFraction(adjusted_speed)
                }
            }
            
            if priorityMode == .shutter {
                let as_double = try convertToDouble(aperture)!
                let adjusted_aperture = as_double * adjustment
                
                compensatedAperture = closestValue(f_stops, adjusted_aperture)
            }
            
            calculatedFactor = true
        } catch {
            presentError = true
        }
    }
    
    private func reset() {
        calculatedFactor = false
        compensatedAperture = 0
        compensatedShutter = ""
    }
}
