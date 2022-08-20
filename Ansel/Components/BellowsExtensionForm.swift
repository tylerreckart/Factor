//
//  BellowsExtensionForm.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct BellowsExtensionForm: View {
    @Binding var priority_mode: PriorityMode
    @Binding var aperture: String
    @Binding var shutter_speed: String
    @Binding var focal_length: String
    @Binding var bellows_draw: String

    var calculate: () -> Void
    
    var body: some View {
        VStack {
            Text("Inputs")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)

            VStack(spacing: -1) {
                if self.priority_mode == .shutter {
                    FormInput(text: $aperture, placeholder: "Aperture")
                        .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.topLeft, .topRight])
                }
                
                if self.priority_mode == .aperture {
                    FormInput(text: $shutter_speed, placeholder: "Shutter Speed")
                        .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.topLeft, .topRight])
                }
                
                FormInput(text: $focal_length, placeholder: "Focal Length (mm)")
                    .border(Color(.systemGray5), width: 1)
                    .background(.white)
                    .zIndex(2)
                FormInput(text: $bellows_draw, placeholder: "Bellows Draw (mm)")
                    .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.bottomLeft, .bottomRight])
                    .padding(.bottom, 15)
                
                CalculateButton(
                    calculate: calculate,
                    isDisabled: self.priority_mode == .aperture ? (self.shutter_speed.count == 0 || self.focal_length.count == 0 || self.bellows_draw.count == 0) : (self.aperture.count == 0 || self.focal_length.count == 0 || self.bellows_draw.count == 0)
                )
            }
        }
    }
}
