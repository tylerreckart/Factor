//
//  Theme.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct AccentColorOption: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var color: Color
    var label: String
    
    @Binding var accentColor: Color

    var body: some View {
        Button(action: {
            userAccentColor = color
            accentColor = color
        }) {
            HStack {
                color
                    .frame(width: 24, height: 24)
                    .cornerRadius(12)
                
                Text(label)
                    .foregroundColor(.primary)
                
                if accentColor == color {
                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                }
            }
            .padding([.top, .bottom], 2)
        }
    }
}

struct ThemeSettings: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @AppStorage("overrideDefaultUIColors") var overrideDefaultColors: Bool = false
    
    @State private var accentColor: Color = .accentColor

    var body: some View {
        List {
            Section(header: Text("Overrides").font(.system(size: 12))) {
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
                AccentColorOption(color: Color(.systemBlue), label: "Levi's", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemCyan), label: "StarKist", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemMint), label: "Breyers", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemGreen), label: "Vlasic", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemYellow), label: "French's", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemOrange), label: "Pepperidge Farm", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemRed), label: "Heinz 57", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemPink), label: "Pepto", accentColor: $accentColor)
                AccentColorOption(color: Color(.systemPurple), label: "Welch's", accentColor: $accentColor)
            }
            .onAppear {
                accentColor = .accentColor
            }
        }
    }
}
