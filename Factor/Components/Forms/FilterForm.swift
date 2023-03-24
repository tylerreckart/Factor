//
//  FilterForm.swift
//  Factor
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

enum FilterFormField: Hashable {
    case shutter
    case aperture
}

struct FilterForm: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    @Binding var priorityMode: PriorityMode
    @Binding var shutterSpeed: String
    @Binding var aperture: String
    @Binding var calculatedFactor: Bool

    var calculate: () -> Void
    var reset: () -> Void

    @Binding var selected: Double
    
    @FocusState private var focusedField: FilterFormField?
    
    func calculateWithFocus() -> Void {
        focusedField = nil
        calculate()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                VStack {
                    PriorityModeToggle(
                        priorityMode: $priorityMode,
                        aperture: $aperture,
                        shutterSpeed:$shutterSpeed,
                        calculatedFactor: $calculatedFactor,
                        reset: self.reset
                    )
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .center) {
                            Text("F-Stop Reduction")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.bottom, 0)
                            
                            Menu {
                                ForEach(1...16, id: \.self) { factor in
                                    Button(action: {
                                        selected = Double(factor)
                                    }) {
                                        Text("\(factor) stop\(factor == 1 ? "" : "s")")
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("\(selected.clean) stop\(selected == 1 ? "" : "s")")
                                    Spacer()
                                }
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .frame(height: 55)
                                .background(useDarkMode ? Color(.systemGray6) : .white)
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
                                FormInput(
                                    text: $shutterSpeed,
                                    placeholder: "1/250"
                                )
                                .background(.background)
                                .focused($focusedField, equals: .shutter)
                                .cornerRadius(7)
                            }
                        }
                        
                        if self.priorityMode == .shutter {
                            VStack(alignment: .center) {
                                Text("Aperture")
                                    .font(.system(size: 12, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                    .padding(.bottom, 0)
                                FormInput(
                                    text: $aperture,
                                    placeholder: "5.6"
                                )
                                .background(.background)
                                .focused($focusedField, equals: .aperture)
                                .cornerRadius(7)
                            }
                        }
                    }
                }
            }
        
            
            CalculateButton(calculate: calculateWithFocus, isDisabled: self.priorityMode == .aperture ? self.shutterSpeed.count == 0 : self.aperture.count == 0)
        }
    }
}
