//
//  FilterForm.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

enum FilterFormField: Hashable {
    case shutter
    case aperture
}

struct FilterForm: View {
    @Binding var priority_mode: PriorityMode
    @Binding var shutter_speed: String
    @Binding var aperture: String
    @Binding var calculated_factor: Bool

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
                priority_mode: $priority_mode,
                aperture: $aperture,
                shutter_speed:$shutter_speed,
                calculated_factor: $calculated_factor,
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
            
                if self.priority_mode == .aperture {
                    FormInput(
                        text: $shutter_speed,
                        placeholder: "Shutter Speed (seconds)"
                    )
                    .background(.background)
                    .focused($focusedField, equals: .shutter)
                    .border(width: 1, edges: [.top], color: Color(.systemGray5))
                    .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
                }
                
                if self.priority_mode == .shutter {
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
        
            
            CalculateButton(calculate: calculateWithFocus, isDisabled: self.priority_mode == .aperture ? self.shutter_speed.count == 0 : self.aperture.count == 0)
                .padding(.top, 5)
        }
    }
}
