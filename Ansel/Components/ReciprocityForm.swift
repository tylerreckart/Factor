//
//  ReciprocityForm.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

enum ReciprocityFormField: Hashable {
    case shutter
}

struct ReciprocityForm: View {
    @Binding var shutter_speed: String

    var calculate: () -> Void
    
    @Binding var selected: ReciprocityDropdownOption
    
    @FocusState private var focusedField: ReciprocityFormField?
    
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
                .padding(.top)
            
            VStack(spacing: -1) {
                HStack {
                    Text("Film Stock")
                        .font(.system(.caption))
                        .frame(height: 55, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing])
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray5))
            
                    Picker("Select a film stock", selection: $selected) {
                        ForEach(reciprocity_options, id: \.self) {
                            Text($0.key)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                }
                .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.topLeft, .topRight])
                
                FormInput(
                    text: $shutter_speed,
                    placeholder: "Shutter Speed (seconds)"
                )
                    .focused($focusedField, equals: .shutter)
                    .padding(.bottom, 4)
                    .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.bottomLeft, .bottomRight])
            }

            CalculateButton(calculate: calculateWithFocus, isDisabled: self.shutter_speed.count == 0)
        }
    }
}

