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
    case focalLength
    case bellowsDraw
}

struct BellowsExtensionForm: View {
    @Binding var priorityMode: PriorityMode
    @Binding var aperture: String
    @Binding var shutterSpeed: String
    @Binding var focalLength: String
    @Binding var bellowsDraw: String

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
                    if self.priorityMode == .shutter {
                        FormInput(text: $aperture, placeholder: "Aperture")
                            .background(.background)
                            .focused($focusedField, equals: .aperture)
                            .cornerRadius(3, corners: [.topLeft, .topRight])
                    }
                    
                    if self.priorityMode == .aperture {
                        FormInput(text: $shutterSpeed, placeholder: "Shutter Speed")
                            .background(.background)
                            .focused($focusedField, equals: .shutter)
                            .cornerRadius(3, corners: [.topLeft, .topRight])
                    }
                    
                    FormInput(text: $focalLength, placeholder: "Focal Length (mm)")
                        .background(.background)
                        .focused($focusedField, equals: .focalLength)
                        .keyboardType(.numberPad)
                        .border(width: 1, edges: [.top], color: Color(.systemGray5))
                        .zIndex(2)
                    
                    FormInput(text: $bellowsDraw, placeholder: "Bellows Draw (mm)")
                        .background(.background)
                        .focused($focusedField, equals: .bellowsDraw)
                        .keyboardType(.numberPad)
                        .border(width: 1, edges: [.top], color: Color(.systemGray5))
                        .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
                }
                .padding(1)
                .background(Color(.systemGray5))
                .cornerRadius(4)
                
                CalculateButton(
                    calculate: calculateWithFocus,
                    isDisabled: self.priorityMode == .aperture ? (self.shutterSpeed.count == 0 || self.focalLength.count == 0 || self.bellowsDraw.count == 0) : (self.aperture.count == 0 || self.focalLength.count == 0 || self.bellowsDraw.count == 0)
                )
                .padding(.top, 5)
            }
        }
    }
}
