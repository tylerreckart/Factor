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

            VStack {
                VStack(spacing: 0) {
                    if self.priority_mode == .shutter {
                        FormInput(text: $aperture, placeholder: "Aperture")
                            .background(.background)
                            .focused($focusedField, equals: .aperture)
                            .cornerRadius(3, corners: [.topLeft, .topRight])
                    }
                    
                    if self.priority_mode == .aperture {
                        FormInput(text: $shutter_speed, placeholder: "Shutter Speed")
                            .background(.background)
                            .focused($focusedField, equals: .shutter)
                            .cornerRadius(3, corners: [.topLeft, .topRight])
                    }
                    
                    FormInput(text: $focal_length, placeholder: "Focal Length (mm)")
                        .background(.background)
                        .focused($focusedField, equals: .focal_length)
                        .keyboardType(.numberPad)
                        .border(width: 1, edges: [.top], color: Color(.systemGray5))
                        .zIndex(2)
                    
                    FormInput(text: $bellows_draw, placeholder: "Bellows Draw (mm)")
                        .background(.background)
                        .focused($focusedField, equals: .bellows_draw)
                        .keyboardType(.numberPad)
                        .border(width: 1, edges: [.top], color: Color(.systemGray5))
                        .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
                }
                .padding(1)
                .background(Color(.systemGray5))
                .cornerRadius(4)
                
                CalculateButton(
                    calculate: calculateWithFocus,
                    isDisabled: self.priority_mode == .aperture ? (self.shutter_speed.count == 0 || self.focal_length.count == 0 || self.bellows_draw.count == 0) : (self.aperture.count == 0 || self.focal_length.count == 0 || self.bellows_draw.count == 0)
                )
                .padding(.top, 5)
            }
        }
    }
}
