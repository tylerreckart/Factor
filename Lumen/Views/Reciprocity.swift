//
//  Reciprocity.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

class ReciprocityValue {
    var name = ""
    var p_factor = Float(0)
    
    init(name: String, p_factor: Float){
        self.name = name
        self.p_factor = p_factor
    }
}

struct DropdownOption: Hashable {
    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var value: Double
}

struct DropdownOptionElement: View {
    var key: String
    var value: Double
    var onSelect: ((_ key: Double) -> Void)?

    var body: some View {
        Button(action: {
            if let onSelect = self.onSelect {
                onSelect(self.value)
            }
        }) {
            Text(self.key)
        }
    }
}

struct Dropdown: View {
    var options: [DropdownOption]
    var onSelect: ((_ key: Double) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(self.options, id: \.self) { option in
                DropdownOptionElement(key: option.key, value: option.value, onSelect: self.onSelect)
            }
        }

        .background(Color.red)
    }
}

struct ReciprocityForm: View {
    @Binding var shutter_speed: String

    var onSelect: ((_ key: Double) -> Void)?
    var calculate: () -> Void
    
    var options = [
        DropdownOption(key: "SFX", value: 1.43),
        DropdownOption(key: "Pan F+", value: 1.33),
        DropdownOption(key: "Delta 100", value: 1.26),
        DropdownOption(key: "Delta 400", value: 1.41),
        DropdownOption(key: "Delta 3200", value: 1.33),
        DropdownOption(key: "FP4+", value: 1.26),
        DropdownOption(key: "HP5+", value: 1.31),
        DropdownOption(key: "XP2", value: 1.31),
        DropdownOption(key: "K100", value: 1.26),
        DropdownOption(key: "K400", value: 1.30),
    ]
    
    var body: some View {
        VStack {
            Text("Parameters")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(.top)
            
            Dropdown(options: options, onSelect: onSelect)
            FormInput(text: $shutter_speed, placeholder: "Shutter Speed (seconds)")
                .padding(.bottom, 4)
            CalculateButton(calculate: calculate)
        }
    }
}

struct Reciprocity: View {
    @State private var shutter_speed: String = ""
    @State private var reciprocity_factor: Double = 0.0
    @State private var adjusted_shutter_speed: String = ""

    var body: some View {
        ScrollView {
            VStack {
                ReciprocityForm(
                    shutter_speed: $shutter_speed,
                    onSelect: self.onSelect,
                    calculate: self.calculate
                )
            }
            .padding()
            .background(.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            .padding([.leading, .trailing, .bottom])

            if !self.adjusted_shutter_speed.isEmpty {
                Text(adjusted_shutter_speed)
                    .foregroundColor(.black)
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Reciprocity")
        .navigationBarTitleDisplayMode(.large)
        .foregroundColor(.white)
    }
    private func calculate() {
        self.adjusted_shutter_speed = "\(pow(Double(self.shutter_speed) ?? 1.0, self.reciprocity_factor))"
    }
    
    private func onSelect(factor: Double) {
        self.reciprocity_factor = factor
    }
}

struct Reciprocity_Previews: PreviewProvider {
    static var previews: some View {
        Reciprocity()
    }
}
