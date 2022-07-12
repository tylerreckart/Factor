//
//  BellowsExtensionForm.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct CalculateButton: View {
    var calculate: () -> Void
    
    var body: some View {
        Button(action: calculate) {
            Text("Calculate")
                .font(.system(.body))
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .padding(14)
        .frame(maxWidth: 180)
        .background(Color(.systemBlue))
        .cornerRadius(24)
        .shadow(color: Color(.systemBlue).opacity(0.25), radius: 6, x: 0, y: 4)
    }
}

struct BellowsExtensionForm: View {
    @Binding var priority_mode: String
    @Binding var aperture: String
    @Binding var shutter_speed: String
    @Binding var focal_length: String
    @Binding var bellows_draw: String

    var calculate: () -> Void
    
    var body: some View {
        VStack {
            Text("Parameters")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(.top)

            if self.priority_mode == "shutter" {
                FormInput(text: $aperture, placeholder: "Aperture")
                    .padding(.bottom, 4)
            }
            
            if self.priority_mode == "aperture" {
                FormInput(text: $shutter_speed, placeholder: "Shutter Speed")
                    .padding(.bottom, 4)
            }
            
            FormInput(text: $focal_length, placeholder: "Focal Length (mm)")
                .padding(.bottom, 4)
            
            FormInput(text: $bellows_draw, placeholder: "Bellows Draw (mm)")
                .padding(.bottom, 4)
            
            if (!self.aperture.isEmpty || !self.shutter_speed.isEmpty) && !self.focal_length.isEmpty && !self.bellows_draw.isEmpty {
                CalculateButton(calculate: calculate)
            }
        }
    }
}
