//
//  FilterForm.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

enum FilterFormField: Hashable {
    case shutter
    case aperture
}

struct FilterForm: View {
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
        VStack {
            PriorityModeToggle(
                priorityMode: $priorityMode,
                aperture: $aperture,
                shutterSpeed:$shutterSpeed,
                calculatedFactor: $calculatedFactor,
                reset: self.reset
            )
            .padding(.top)

            Text("Inputs")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
            
            VStack(spacing: 0) {
                HStack {
                    Text("F-Stop Reduction")
                        .font(.system(.caption))
                        .frame(height: 55, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing])
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray5))
            
                    HStack {
                        Spacer()
                        Menu {
                            ForEach(1...16, id: \.self) { factor in
                                Button(action: {
                                    selected = Double(factor)
                                }) {
                                    Text("\(factor)")
                                }
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("\(selected.clean)")
                                Spacer()
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                    .frame(height: 55, alignment: .trailing)
                    .background(.background)
                }
                .cornerRadius(3, corners: [.topLeft, .topRight])
            
                if self.priorityMode == .aperture {
                    FormInput(
                        text: $shutterSpeed,
                        placeholder: "Shutter Speed (seconds)"
                    )
                    .background(.background)
                    .focused($focusedField, equals: .shutter)
                    .border(width: 1, edges: [.top], color: Color(.systemGray5))
                    .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
                }
                
                if self.priorityMode == .shutter {
                    FormInput(
                        text: $aperture,
                        placeholder: "Aperture"
                    )
                    .background(.background)
                    .focused($focusedField, equals: .aperture)
                    .border(width: 1, edges: [.top], color: Color(.systemGray5))
                    .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
                }
            }
            .padding(1)
            .background(Color(.systemGray5))
            .cornerRadius(4)
        
            
            CalculateButton(calculate: calculateWithFocus, isDisabled: self.priorityMode == .aperture ? self.shutterSpeed.count == 0 : self.aperture.count == 0)
                .padding(.top, 5)
        }
    }
}
