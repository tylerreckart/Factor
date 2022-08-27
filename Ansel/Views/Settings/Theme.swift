//
//  Theme.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct AccentColorOption: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var color: Color
    var label: String

    var body: some View {
        Button(action: {
            userAccentColor = color
        }) {
            HStack {
                color
                    .frame(width: 24, height: 24)
                    .cornerRadius(12)
                
                Text(label)
                    .foregroundColor(.primary)
            }
            .padding([.top, .bottom], 2)
        }
    }
}

struct ThemeSettings: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @AppStorage("overrideDefaultUIColors") var overrideDefaultColors: Bool = false

    var body: some View {
        List {
            Section {
                Toggle(isOn: $useDarkMode) {
                    Text("Always Use Dark Theme")
                }
                .toggleStyle(SwitchToggleStyle(tint: userAccentColor))
                
                Toggle(isOn: $overrideDefaultColors) {
                    Text("Override Default Colors")
                }
                .toggleStyle(SwitchToggleStyle(tint: userAccentColor))
            }
            
            Section(header: Text("Accent Color").font(.system(size: 12))) {
                AccentColorOption(color: Color(.systemBlue), label: "Levi's")
                AccentColorOption(color: Color(.systemCyan), label: "StarKist")
                AccentColorOption(color: Color(.systemMint), label: "Breyers")
                AccentColorOption(color: Color(.systemGreen), label: "Vlasic")
                AccentColorOption(color: Color(.systemYellow), label: "French's")
                AccentColorOption(color: Color(.systemOrange), label: "Pepperidge Farm")
                AccentColorOption(color: Color(.systemRed), label: "Heinz 57")
                AccentColorOption(color: Color(.systemPink), label: "Pepto")
                AccentColorOption(color: Color(.systemPurple), label: "Welch's")
            }
        }
    }
}
