//
//  FilterForm.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct FilterForm: View {
    @Binding var priority_mode: PriorityMode
    @Binding var shutter_speed: String
    @Binding var aperture: String
    @Binding var calculated_factor: Bool

    var calculate: () -> Void
    var reset: () -> Void
    
    var options = [
        FilterDropdownOption(key: "1", value: 1),
        FilterDropdownOption(key: "2", value: 2),
        FilterDropdownOption(key: "3", value: 3),
        FilterDropdownOption(key: "4", value: 4),
        FilterDropdownOption(key: "5", value: 5),
        FilterDropdownOption(key: "6", value: 6),
        FilterDropdownOption(key: "7", value: 7),
        FilterDropdownOption(key: "8", value: 8),
        FilterDropdownOption(key: "9", value: 9),
        FilterDropdownOption(key: "10", value: 10),
    ]
    
    @Binding var selected: FilterDropdownOption
    
    var body: some View {
        VStack {
            PriorityModeToggle(
                priority_mode: $priority_mode,
                aperture: $aperture,
                shutter_speed:$shutter_speed,
                calculated_factor: $calculated_factor,
                reset: self.reset
            )

            Text("Inputs")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
            
            VStack(spacing: -1) {
                HStack {
                    Text("F-Stop Reduction")
                        .font(.system(.caption))
                        .frame(height: 55, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing])
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray5))
            
                    Picker("Select a filter factor", selection: $selected) {
                        ForEach(options, id: \.self) {
                            Text($0.key)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                }
                .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.topLeft, .topRight])
            
                if self.priority_mode == .aperture {
                    FormInput(
                        text: $shutter_speed,
                        placeholder: "Shutter Speed (seconds)"
                    )
                    .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.bottomLeft, .bottomRight])
                }
                
                if self.priority_mode == .shutter {
                    FormInput(
                        text: $aperture,
                        placeholder: "Aperture"
                    )
                    .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.bottomLeft, .bottomRight])
                }
            }
            
            CalculateButton(calculate: calculate, isDisabled: self.priority_mode == .aperture ? self.shutter_speed.count == 0 : self.aperture.count == 0)
        }
        .padding(.top)
    }
}
