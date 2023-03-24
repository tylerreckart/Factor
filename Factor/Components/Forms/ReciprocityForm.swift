//
//  ReciprocityForm.swift
//  Factor
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

enum ReciprocityFormField: Hashable {
    case shutter
}

struct ReciprocityForm: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    @FetchRequest(
      entity: Emulsion.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Emulsion.manufacturer, ascending: true)
      ]
    ) var emulsions: FetchedResults<Emulsion>

    @Binding var shutterSpeed: String

    var calculate: () -> Void
    
    @Binding var selected: Emulsion?

    @State private var showEmulsionPicker: Bool = false
    
    @FocusState private var focusedField: ReciprocityFormField?
    
    func calculateWithFocus() -> Void {
        focusedField = nil
        calculate()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                VStack(alignment: .center) {
                    Text("Film Stock")
                        .font(.system(size: 12, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.bottom, 0)
                    Button(action: {
                        showEmulsionPicker.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Menu {
                                ForEach(emulsions, id: \.self) { emulsion in
                                    Button(action: {
                                        selected = emulsion
                                    }) {
                                        Text(emulsion.name!)
                                    }
                                }
                            } label: {
                                if selected == nil {
                                    Text("Emulsion")
                                        .padding(.horizontal)
                                        .foregroundColor(.gray)
                                    Spacer()
                                } else {
                                    let option = selected!
                                    
                                    HStack {
                                        Text(option.name ?? "")
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                    .foregroundColor(.primary)
                                }
                            }
                        }
                        .frame(height: 55, alignment: .trailing)
                        .background(useDarkMode ? Color(.systemGray6) : .white)
                        .cornerRadius(8)
                    }
                }
                
                VStack {
                    Text("Shutter Speed")
                        .font(.system(size: 12, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.bottom, 0)
                    FormInput(text: $shutterSpeed, placeholder: "3 seconds")
                        .background(.background)
                        .focused($focusedField, equals: .shutter)
                        .cornerRadius(8)
                }
            }

            CalculateButton(calculate: calculateWithFocus, isDisabled: self.shutterSpeed.count == 0)
        }
    }
}

