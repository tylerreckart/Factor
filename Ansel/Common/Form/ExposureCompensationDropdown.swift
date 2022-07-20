//
//  ExposureCompensationDropdown.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/16/22.
//
import SwiftUI

struct ExposureCompensationDropdownOption: Hashable {
    public static func == (lhs: ExposureCompensationDropdownOption, rhs: ExposureCompensationDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var value: Double
}

struct ExposureCompensationDropdownOptionElement: View {
    var key: String
    var value: Double
    var onSelect: ((_ key: ExposureCompensationDropdownOption) -> Void)?
    var selected: Bool
    
    @Binding var shouldShowDropdown: Bool

    var body: some View {
        Button(action: {
            if let onSelect = self.onSelect {
                onSelect(ExposureCompensationDropdownOption(key: self.key, value: self.value))
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

struct ExposureCompensationDropdown: View {
    var options: [ExposureCompensationDropdownOption]
    var onSelect: ((_ key: ExposureCompensationDropdownOption) -> Void)?
    var selected: String
    
    @Binding var shouldShowDropdown: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                ForEach(self.options, id: \.self) { option in
                    ExposureCompensationDropdownOptionElement(
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

struct ExposureCompensationDropdownButton: View {
    @State var shouldShowDropdown = false
    @Binding var displayText: String

    var options: [ExposureCompensationDropdownOption]

    var onSelect: ((_ key: ExposureCompensationDropdownOption) -> Void)?
    
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
                ExposureCompensationDropdown(
                    options: options,
                    onSelect: onSelect,
                    selected: self.selected,
                    shouldShowDropdown: $shouldShowDropdown
                )
            }
        }
    }
}
