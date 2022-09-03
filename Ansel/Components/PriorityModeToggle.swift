//
//  PriorityModeToggle.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI

enum PriorityMode: String, CaseIterable, Identifiable {
    case aperture, shutter
    var id: Self { self }
}

struct ToggleButton: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    @Binding var aperture: String
    @Binding var shutter: String
    @Binding var priorityMode: PriorityMode
    @Binding var calculated: Bool
    
    var label: String
    var target: PriorityMode
    var reset: () -> Void
    
    var body: some View {
        Button(action: {
            priorityMode = target
            
            // Reset existing values if toggle is changed after calculation
            if target == .shutter {
                aperture = ""
            } else {
                shutter = ""
            }

            if (calculated == true) {
                reset()
            }
        }) {
            Text(label)
                .font(.system(.caption))
                .fontWeight(.bold)
        }
        .foregroundColor(
            self.priorityMode == target
                ? .white
                : Color(.systemGray)
        )
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(self.priorityMode == target ? userAccentColor : .clear)
        .overlay(self.priorityMode == target
                 ? LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom)
                 : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(4)
    }
}

struct PriorityModeToggle: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    @Binding var priorityMode: PriorityMode
    @Binding var aperture: String
    @Binding var shutterSpeed: String
    @Binding var calculatedFactor: Bool

    var reset: () -> Void

    var body: some View {
        VStack {
            Text("Priority Mode")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)

            VStack {
                HStack {
                    ToggleButton(
                        aperture: $aperture,
                        shutter: $shutterSpeed,
                        priorityMode: $priorityMode,
                        calculated: $calculatedFactor,
                        label: "Aperture",
                        target: .aperture,
                        reset: reset
                    )

                    ToggleButton(
                        aperture: $aperture,
                        shutter: $shutterSpeed,
                        priorityMode: $priorityMode,
                        calculated: $calculatedFactor,
                        label: "Shutter Speed",
                        target: .shutter,
                        reset: reset
                    )
                }
            }
            .padding(4)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.bottom, 10)
    }
}
