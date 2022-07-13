//
//  Reciprocity.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct ReciprocityCard: View {
    var label: String
    var icon: String
    var result: String
    var background: Color
    var foreground: Color = .white

    var body: some View {
        VStack {
            Image(systemName: icon)
                .imageScale(.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text(label)
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Spacer()
            Text(result)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.title, design: .rounded))
        }
        .foregroundColor(foreground)
        .frame(height:125, alignment: .topLeading)
        .padding()
        .background(background)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct ReciprocityForm: View {
    @Binding var shutter_speed: String

    var onSelect: ((_ key: ReciprocityDropdownOption) -> Void)?
    var calculate: () -> Void
    
    var options = [
        ReciprocityDropdownOption(key: "SFX", value: 1.43),
        ReciprocityDropdownOption(key: "Pan F+", value: 1.33),
        ReciprocityDropdownOption(key: "Delta 100", value: 1.26),
        ReciprocityDropdownOption(key: "Delta 400", value: 1.41),
        ReciprocityDropdownOption(key: "Delta 3200", value: 1.33),
        ReciprocityDropdownOption(key: "FP4+", value: 1.26),
        ReciprocityDropdownOption(key: "HP5+", value: 1.31),
        ReciprocityDropdownOption(key: "XP2", value: 1.31),
        ReciprocityDropdownOption(key: "K100", value: 1.26),
        ReciprocityDropdownOption(key: "K400", value: 1.30),
    ]
    
    @Binding var selected: String
    
    var body: some View {
        VStack {
            Text("Parameters")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(.top)
            
            ReciprocityDropdownButton(
                displayText: $selected,
                options: options,
                onSelect: onSelect,
                selected: $selected
            )
                .zIndex(2)
            
            FormInput(
                text: $shutter_speed,
                placeholder: "Shutter Speed (seconds)"
            )
                .padding(.bottom, 4)
                .zIndex(1)
            CalculateButton(calculate: calculate)
                .zIndex(1)
        }
    }
}

struct Reciprocity: View {
    @State private var shutter_speed: String = ""
    @State private var reciprocity_factor: Double = 1.43
    @State private var adjusted_shutter_speed: String = ""
    @State private var selected: String = "SFX"

    var body: some View {
        ScrollView {
            VStack {
                ReciprocityForm(
                    shutter_speed: $shutter_speed,
                    onSelect: self.onSelect,
                    calculate: self.calculate,
                    selected: $selected
                )
            }
            .padding([.leading, .trailing, .bottom])
            .background(.background)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            .padding([.leading, .trailing, .bottom])

            if !self.adjusted_shutter_speed.isEmpty {
                ReciprocityCard(
                    label: "Adjusted shutter speed",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(Double(adjusted_shutter_speed) ?? 1))) seconds",
                    background: Color(.systemPurple)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Reciprocity")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            HStack {
                Label("History", systemImage: "clock.arrow.circlepath")
                Text("History")
            }
            .foregroundColor(Color(.systemBlue))
        }
    }
    private func calculate() {
        self.adjusted_shutter_speed = "\(pow(Double(self.shutter_speed) ?? 1.0, self.reciprocity_factor))"
    }
    
    private func onSelect(option: ReciprocityDropdownOption) {
        self.reciprocity_factor = option.value
        self.selected = option.key
    }
}

struct Reciprocity_Previews: PreviewProvider {
    static var previews: some View {
        Reciprocity()
    }
}
