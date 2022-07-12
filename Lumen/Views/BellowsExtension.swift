//
//  BellowsExtension.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI

struct CompensationFactorCard: View {
    var label: String
    var icon: String
    var result: String
    var background: Color
    var foreground: Color = .white

    var body: some View {
        VStack {
            Image(systemName: icon)
                .imageScale(.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text(label)
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Spacer()
            Text(result)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.title, design: .rounded))
        }
        .foregroundColor(foreground)
        .frame(height:125, alignment: .topLeading)
        .padding()
        .background(background)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct BellowsExtension: View {
    @State private var aperture: String = ""
    @State private var iso: String = ""
    @State private var shutter_speed: String = ""
    @State private var bellows_draw: String = ""
    @State private var focal_length: String = ""

    @State private var extension_factor: String = ""
    @State private var calculated_factor: Bool = false

    @State private var compensated_aperture: String = ""
    @State private var compensated_shutter: String = ""

    @State private var priority_mode: String = "aperture"

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
            .background(.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            .padding([.leading, .trailing, .bottom])

            if self.calculated_factor == true {
                HStack(spacing: 20) {
                    CompensationFactorCard(
                        label: "Bellows extension factor",
                        icon: "arrow.up.left.and.arrow.down.right.circle.fill",
                        result: extension_factor,
                        background: Color(.systemBlue)
                    )
                    
                    if (self.priority_mode == "shutter") {
                        CompensationFactorCard(
                            label: "Compensated aperture",
                            icon: "f.cursive.circle.fill",
                            result: "f/\(compensated_aperture)",
                            background: Color(.systemGreen)
                        )
                    }

                    if (self.priority_mode == "aperture") {
                        CompensationFactorCard(
                            label: "Compensated shutter speed",
                            icon: "clock.circle.fill",
                            result: self.compensated_shutter,
                            background: Color(.systemPurple)
                        )
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Bellows Extension")
        .navigationBarTitleDisplayMode(.large)
        .foregroundColor(.white)
    }
    
    private func calculate() {
        let bellows_draw = Int(self.bellows_draw) ?? 1;
        let focal_length = Int(self.focal_length) ?? 1;
        
        // (Extension/FocalLength) **2
        let factor = Float(pow(Float(bellows_draw/focal_length), 2))
        
        if focal_length > 0 && bellows_draw > 0 {
            self.extension_factor = "\(Int(factor))"
            self.calculated_factor = true
            
            if self.priority_mode == "shutter" {
                let aperture_compensation = log(factor)/log(2)

                self.compensated_aperture = "\(Int(aperture_compensation * (Float(aperture) ?? 1)!))"
            }
            
            if self.priority_mode == "aperture" {
                let shutter_index = shutter_speed_range.indices.filter { shutter_speed_range[$0] == shutter_speed }[0]

                self.compensated_shutter = "\(shutter_speed_range[shutter_index - (Int(factor) / 2)])"
            }
        }
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
