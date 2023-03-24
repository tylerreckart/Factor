//
//  Reciprocity.swift
//  Factor
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct Reciprocity: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var open: Bool
    
    @State private var shutterSpeed: String = ""
    @State private var reciprocity_factor: Double = 1.43
    @State private var adjustedShutterSpeed: Double?
    @State private var selected: Emulsion?
    @State private var calculated: Bool = false
    
    @State private var showingHistorySheet: Bool = false
    
    @State private var presentError: Bool = false
    
    var body: some View {
        Dialog(
            content: {
                ReciprocityForm(
                    shutterSpeed: $shutterSpeed,
                    calculate: calculate,
                    selected: $selected
                )
            },
            calculatedContent: {
                CalculatedResultCard(
                    label: "Adjusted shutter speed",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(adjustedShutterSpeed ?? 0))) seconds",
                    background: Color(.systemPurple)
                )
            },
            open: $open,
            calculated: $calculated
        )
    }

    private func calculate() -> Void {
        let threshold: Int32? = selected?.threshold ?? nil

        if threshold != nil {
            do {
                let thresholdDouble = try convertToDouble(String(selected!.threshold))!
                let asDouble = try convertToDouble(shutterSpeed)!
                
                if thresholdDouble < asDouble {
                    adjustedShutterSpeed = pow(asDouble, selected!.pFactor)
                } else {
                    adjustedShutterSpeed = Double(shutterSpeed)
                }
                
                self.calculated = true
            } catch {
                presentError = true
                return
            }
        } else {
            presentError = true
            return
        }
    }
}
