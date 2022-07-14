//
//  ReciprocityDropdown.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/12/22.
//
import SwiftUI

struct ReciprocityDropdownOption: Hashable {
    public static func == (lhs: ReciprocityDropdownOption, rhs: ReciprocityDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var value: Double
}

struct ReciprocityDropdownOptionElement: View {
    var key: String
    var value: Double
    var onSelect: ((_ key: ReciprocityDropdownOption) -> Void)?
    var selected: Bool
    
    @Binding var shouldShowDropdown: Bool

    var body: some View {
        Button(action: {
            if let onSelect = self.onSelect {
                onSelect(ReciprocityDropdownOption(key: self.key, value: self.value))
                self.shouldShowDropdown.toggle()
            }
        }) {
            Text(self.key)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.body))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(Color.primary)
        .background(selected ? Color(.systemGray5) : .clear)
    }
}

struct ReciprocityDropdown: View {
    var options: [ReciprocityDropdownOption]
    var onSelect: ((_ key: ReciprocityDropdownOption) -> Void)?
    var selected: String
    
    @Binding var shouldShowDropdown: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                ForEach(self.options, id: \.self) { option in
                    ReciprocityDropdownOptionElement(
                        key: option.key,
                        value: option.value,
                        onSelect: self.onSelect,
                        selected: option.key == selected ? true : false,
                        shouldShowDropdown: $shouldShowDropdown
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: 238)
        .background(Color(.systemGray6))
        .cornerRadius(24)
    }
}

struct ReciprocityDropdownButton: View {
    @State var shouldShowDropdown = false
    @Binding var displayText: String

    var options: [ReciprocityDropdownOption]

    var onSelect: ((_ key: ReciprocityDropdownOption) -> Void)?
    
    @Binding var selected: String

    let buttonHeight: CGFloat = 30

    var body: some View {
        VStack {
            Button(action: {
                self.shouldShowDropdown.toggle()
            }) {
                HStack {
                    Text(displayText)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: self.shouldShowDropdown ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color(hex: 0xa4a9ab))
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: self.buttonHeight)
            .padding(14)
            .background(Color(.systemGray6))
            .cornerRadius(24)
            
            if self.shouldShowDropdown {
                ReciprocityDropdown(
                    options: options,
                    onSelect: onSelect,
                    selected: self.selected,
                    shouldShowDropdown: $shouldShowDropdown
                )
            }
        }
    }
}
