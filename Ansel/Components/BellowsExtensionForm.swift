//
//  BellowsExtensionForm.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

enum BellowsExtensionFormField: Hashable {
    case aperture
    case shutter
    case focal_length
    case bellows_draw
}

struct BellowsExtensionForm: View {
    @Binding var priority_mode: PriorityMode
    @Binding var aperture: String
    @Binding var shutter_speed: String
    @Binding var focal_length: String
    @Binding var bellows_draw: String

    var calculate: () -> Void
    
    @FocusState private var focusedField: BellowsExtensionFormField?
    
    func calculateWithFocus() -> Void {
        focusedField = nil
        calculate()
    }
    
    var body: some View {
        VStack {
            Text("Inputs")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)

            VStack(spacing: -1) {
                if self.priority_mode == .shutter {
                    FormInput(text: $aperture, placeholder: "Aperture")
                        .focused($focusedField, equals: .aperture)
                        .keyboardType(.numberPad)
                        .addBorder(Color(.systemGray5), width: 1, cornerRadius: 0, corners: [.topLeft, .topRight])
                }
                
                if self.priority_mode == .aperture {
                    FormInput(text: $shutter_speed, placeholder: "Shutter Speed")
                        .focused($focusedField, equals: .shutter)
                        .keyboardType(.numberPad)
                        .addBorder(Color(.systemGray5), width: 1, cornerRadius: 0, corners: [.topLeft, .topRight])
                }
                
                FormInput(text: $focal_length, placeholder: "Focal Length (mm)")
                    .focused($focusedField, equals: .focal_length)
                    .keyboardType(.numberPad)
                    .border(Color(.systemGray5), width: 1)
                    .background(.white)
                    .zIndex(2)

                FormInput(text: $bellows_draw, placeholder: "Bellows Draw (mm)")
                    .focused($focusedField, equals: .bellows_draw)
                    .keyboardType(.numberPad)
                    .addBorder(Color(.systemGray5), width: 1, cornerRadius: 0, corners: [.bottomLeft, .bottomRight])
                    .padding(.bottom, 15)
                
                CalculateButton(
                    calculate: calculateWithFocus,
                    isDisabled: self.priority_mode == .aperture ? (self.shutter_speed.count == 0 || self.focal_length.count == 0 || self.bellows_draw.count == 0) : (self.aperture.count == 0 || self.focal_length.count == 0 || self.bellows_draw.count == 0)
                )
            }
        }
    }
}
