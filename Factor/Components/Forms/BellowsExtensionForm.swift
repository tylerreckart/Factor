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
    @Binding var calculatedFactor: Bool

    var calculate: () -> Void
    var reset: () -> Void
    
    @FocusState private var focusedField: BellowsExtensionFormField?
    
    func calculateWithFocus() -> Void {
        focusedField = nil
        calculate()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                PriorityModeToggle(
                    priorityMode: $priorityMode,
                    aperture: $aperture,
                    shutterSpeed:$shutterSpeed,
                    calculatedFactor: $calculatedFactor,
                    reset: reset
                )
                
                VStack(spacing: 15) {
                    if self.priorityMode == .shutter {
                        VStack(alignment: .center) {
                            Text("Aperture")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.bottom, 0)
                            FormInput(text: $aperture, placeholder: "5.6")
                                .background(.background)
                                .focused($focusedField, equals: .aperture)
                                .cornerRadius(8)
                        }
                    }
                    
                    if self.priorityMode == .aperture {
                        VStack(alignment: .center) {
                            Text("Shutter Speed")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.bottom, 0)
                            FormInput(text: $shutterSpeed, placeholder: "1/250")
                                .background(.background)
                                .focused($focusedField, equals: .shutter)
                                .cornerRadius(8)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .center) {
                            Text("Focal Length (mm)")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.bottom, 0)
                            FormInput(text: $focalLength, placeholder: "90")
                                .background(.background)
                                .focused($focusedField, equals: .focalLength)
                                .keyboardType(.numberPad)
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .center) {
                            Text("Bellows Draw (mm)")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.bottom, 0)
                            FormInput(text: $bellowsDraw, placeholder: "360")
                                .background(.background)
                                .focused($focusedField, equals: .bellowsDraw)
                                .keyboardType(.numberPad)
                                .cornerRadius(8)
                        }
                    }
                }
            }
                
            CalculateButton(
                calculate: calculateWithFocus,
                isDisabled: self.priorityMode == .aperture ? (self.shutterSpeed.count == 0 || self.focalLength.count == 0 || self.bellowsDraw.count == 0) : (self.aperture.count == 0 || self.focalLength.count == 0 || self.bellowsDraw.count == 0)
            )
        }
    }
}
