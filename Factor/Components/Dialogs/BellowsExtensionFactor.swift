//
//  BellowsExtension.swift
//  Factor
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI
import UIKit

struct BellowsExtension: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext

    @Binding var open: Bool

    @State private var priorityMode: PriorityMode = .aperture

    @State private var aperture: String = ""
    @State private var shutterSpeed: String = ""
    @State private var delimiter: Character = "/"
    @State private var bellowsDraw: String = ""
    @State private var focalLength: String = ""

    @State private var calculatedFactor: Bool = false
    @State private var extensionFactor: String = ""

    @State private var compensatedAperture: String = ""
    @State private var compensatedShutter: String = ""
    
    @State private var presentError: Bool = false
    
    var body: some View {
        Dialog(
            content: {
                BellowsExtensionForm(
                    priorityMode: $priorityMode,
                    aperture: $aperture,
                    shutterSpeed: $shutterSpeed,
                    focalLength: $focalLength,
                    bellowsDraw: $bellowsDraw,
                    calculatedFactor: $calculatedFactor,
                    calculate: calculate,
                    reset: reset
                )
            },
            calculatedContent: {
                HStack(spacing: 20) {
                    CalculatedResultCard(
                        label: "Bellows extension factor",
                        icon: "arrow.up.left.and.arrow.down.right.circle.fill",
                        result: extensionFactor,
                        background: Color(.systemBlue)
                    )
                    
                    if (priorityMode == .shutter) {
                        CalculatedResultCard(
                            label: "Compensated aperture",
                            icon: "f.cursive.circle.fill",
                            result: "f/\(compensatedAperture)",
                            background: Color(.systemGreen)
                        )
                    }

                    if (priorityMode == .aperture) {
                        CalculatedResultCard(
                            label: "Compensated shutter speed (seconds)",
                            icon: "clock.circle.fill",
                            result: compensatedShutter,
                            background: Color(.systemPurple)
                        )
                    }
                }
            },
            open: $open,
            calculated: $calculatedFactor
        )
    }
    
    private func bellowsExtensionFactor() -> Double? {
        do {
            let bellowsDraw = try convertToDouble(bellowsDraw)!;
            let focalLength = try convertToDouble(focalLength)!;
            
            let ratio = bellowsDraw / focalLength
            
            return pow(ratio, 2);
        } catch {
            presentError = true
            return nil
        }
    }
    
    private func noCompensation(_ factor: Double) {
        if priorityMode == .shutter {
            compensatedAperture = "\(aperture)"
        } else {
            compensatedShutter = "\(shutterSpeed)"
        }

        extensionFactor = "\(Int(factor))"
        calculatedFactor = true
    }
    
    private func calculate() {
        let factor = bellowsExtensionFactor()
        
        // If the compensation factor is less than 2, not enough light is lost
        // to warrant additional exposure time. Return the original inputs.
        if factor != nil && factor! < 2 {
            noCompensation(factor!)
            return
        }
        
        if factor != nil {
            if priorityMode == .shutter {
                do {
                    // Shutter priority mode
                    let adjustment = pow(2, log2(factor!))
                    let asDouble = try convertToDouble(aperture)
                    let adjustedAperture = asDouble! * (adjustment / 2)
                    
                    compensatedAperture = "\(closestValue(f_stops, adjustedAperture).clean)"
                } catch {
                    presentError = true
                    return
                }
            } else {
                // Aperture priority mode
                if shutterSpeed.contains(delimiter) {
                    do {
                        // 1/x shutter speed
                        let arr = shutterSpeed.split(separator: delimiter)
                        
                        let numerator = try convertToDouble(String(arr[0]))
                        let denominator = try convertToDouble(String(arr[1]));
                        
                        // If either the numerator or denominator does not exist,
                        // a proper exposure cannot be calculated. Throw an error.
                        if numerator == nil || denominator == nil {
                            presentError = true
                        }
                        
                        let factoredNumerator = numerator! * factor!
                        let factoredDenominator = denominator! / factoredNumerator
                        let rationalSpeed = 1 / factoredDenominator
                        
                        if rationalSpeed < 1.0 {
                            var scaledDenominator = Int(factoredDenominator)
                            
                            if factoredDenominator > 10 {
                                scaledDenominator = Int(toNearestTen(Int(factoredDenominator)))
                            }
                            
                            compensatedShutter = "1/\(scaledDenominator)"
                        } else {
                            compensatedShutter = "\(Int(rationalSpeed.rounded(.down)))"
                        }
                    } catch {
                        presentError = true
                        return
                    }
                } else {
                    do {
                        var asDouble: Double?
                        if priorityMode == .shutter {
                            asDouble = try convertToDouble(aperture)
                        } else {
                            asDouble = try convertToDouble(shutterSpeed)
                        }
                        let adjustedShutter: Int = Int(factor! * asDouble!)
                        
                        compensatedShutter = "\(adjustedShutter)"
                    } catch {
                        presentError = true
                        return
                    }
                }
            }
            
            extensionFactor = "\(Int(factor!))"
            calculatedFactor = true
        }
    }
    
    private func reset() {
        calculatedFactor = false
        compensatedAperture = ""
        compensatedShutter = ""
    }
}
