//
//  BellowsExtension.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI
import UIKit

struct BellowsExtension: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var priority_mode: PriorityMode = .aperture

    @State private var aperture: String = ""
    @State private var shutter_speed: String = ""
    @State private var fractional_delimiter: Character = "/"
    @State private var bellows_draw: String = ""
    @State private var focal_length: String = ""

    @State private var calculated_factor: Bool = false
    @State private var extension_factor: String = ""

    @State private var compensated_aperture: String = ""
    @State private var compensated_shutter: String = ""
    
    @State private var showingHistorySheet: Bool = false
    
    @State private var error: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                PriorityModeToggle(
                    priority_mode: $priority_mode,
                    aperture: $aperture,
                    shutter_speed:$shutter_speed,
                    calculated_factor: $calculated_factor,
                    reset: self.reset
                )

                BellowsExtensionForm(
                    priority_mode: $priority_mode,
                    aperture: $aperture,
                    shutter_speed: $shutter_speed,
                    focal_length: $focal_length,
                    bellows_draw: $bellows_draw,
                    calculate: self.calculate
                )
            }
            .padding()
            .background(.background)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            .padding([.leading, .trailing, .bottom])

            if self.calculated_factor == true {
                HStack(spacing: 20) {
                    CalculatedResultCard(
                        label: "Bellows extension factor",
                        icon: "arrow.up.left.and.arrow.down.right.circle.fill",
                        result: extension_factor,
                        background: Color(.systemBlue)
                    )
                    
                    if (self.priority_mode == .shutter) {
                        CalculatedResultCard(
                            label: "Compensated aperture",
                            icon: "f.cursive.circle.fill",
                            result: "f/\(compensated_aperture)",
                            background: Color(.systemGreen),
                            delay: 0.1
                        )
                    }

                    if (self.priority_mode == .aperture) {
                        CalculatedResultCard(
                            label: "Compensated shutter speed (seconds)",
                            icon: "clock.circle.fill",
                            result: self.compensated_shutter,
                            background: Color(.systemPurple),
                            delay: 0.1
                        )
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Bellows Extension")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(.white)
        .toolbar {
            HStack {
                Button(action: {
                    self.showingHistorySheet.toggle()
                }) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                    Text("History")
                }
            }
            .foregroundColor(Color(.systemBlue))
        }
        .sheet(isPresented: $showingHistorySheet) {
            BellowsExtensionHistorySheet()
        }
    }
    
    private func bellowsExtensionFactor() -> Double {
        let bellows_draw = Double(self.bellows_draw) ?? 1.0;
        let focal_length = Double(self.focal_length) ?? 1.0;
        
        let ratio = bellows_draw / focal_length
        
        return pow(ratio, 2);
    }
    
    private func calculate() {
        let factor = bellowsExtensionFactor()
        
        if self.priority_mode == .shutter {
            // Shutter priority mode
            let adjustment = pow(2, log2(factor))
            let adjusted_aperture = Double(self.aperture)! * (adjustment / 2)

            self.compensated_aperture = "\(Int(closestValue(f_stops, adjusted_aperture)))"
        } else {
            // Aperture priority mode
            if self.shutter_speed.contains(fractional_delimiter) {
                // 1/x shutter speed
                let arr = self.shutter_speed.split(separator: fractional_delimiter)
                
                let numerator = Double(arr[0])
                let denominator = Double(arr[1]);
                
                // If either the numerator or denominator does not exist,
                // a proper exposure cannot be calculated. Throw an error.
                if numerator == nil || denominator == nil {
                    self.error = true
                }
                
                let factored_numerator = numerator! * factor
                let factored_denominator = denominator! / factored_numerator
                let rational_speed = 1 / factored_denominator
                
                if rational_speed < 1.0 {
                    var scaled_denominator = Int(factored_denominator)

                    if factored_denominator > 10 {
                        scaled_denominator = Int(toNearestTen(Int(factored_denominator)))
                    }

                    self.compensated_shutter = "1/\(scaled_denominator)"
                } else {
                    self.compensated_shutter = "\(Int(rational_speed.rounded(.down)))"
                }
            } else {
                let adjusted_shutter: Int = Int(factor * Double(self.shutter_speed)!)
                
                self.compensated_shutter = "\(adjusted_shutter)"
            }
        }
        
        self.extension_factor = "\(Int(factor))"
        self.calculated_factor = true
        
        save()
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func save() {
        let newExtensionData = BellowsExtensionData(context: managedObjectContext)
        newExtensionData.aperture = self.aperture
        newExtensionData.shutterSpeed = self.shutter_speed
        newExtensionData.bellowsDraw = self.bellows_draw
        newExtensionData.focalLength = self.focal_length
        newExtensionData.compensatedAperture = self.compensated_aperture
        newExtensionData.compensatedShutter = self.compensated_shutter
        newExtensionData.bellowsExtensionFactor = self.extension_factor
        newExtensionData.timestamp = Date()

        saveContext()
    }
    
    private func reset() {
        self.calculated_factor = false
        self.compensated_aperture = ""
        self.compensated_shutter = ""
    }
}

struct BellowsExtension_Previews: PreviewProvider {
    static var previews: some View {
        BellowsExtension()
    }
}
