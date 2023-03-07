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
        VStack {
            VStack(spacing: -1) {
                VStack {
                    HStack {
                        Text("Film Stock")
                            .font(.system(.caption))
                            .frame(height: 55, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding([.leading, .trailing])
                            .background(Color(.systemGray6))
                            .border(width: 1, edges: [.trailing], color: Color(.systemGray5))
                        
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
                                        Spacer()
                                        Text("Select an Emulsion")
                                            .foregroundColor(.accentColor)
                                        Spacer()
                                    } else {
                                        let option = selected!
                                        
                                        HStack {
                                            Spacer()
                                            Text("\(option.manufacturer!) \(option.name!)")
                                            Spacer()
                                        }
                                        .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .frame(height: 55, alignment: .trailing)
                            .background(.background)
                        }
                    }
                }
                .cornerRadius(3, corners: [.topLeft, .topRight])
                
                FormInput(text: $shutterSpeed, placeholder: "Shutter Speed (seconds)")
                    .background(.background)
                    .border(width: 1, edges: [.top], color: Color(.systemGray5))
                    .focused($focusedField, equals: .shutter)
                    .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
            }
            .padding(1)
            .background(Color(.systemGray5))
            .cornerRadius(4)

            CalculateButton(calculate: calculateWithFocus, isDisabled: self.shutterSpeed.count == 0)
                .padding(.top, 5)
        }
    }
}

