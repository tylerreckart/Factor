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

struct PriorityModeToggle: View {
    @Binding var priority_mode: PriorityMode
    @Binding var aperture: String
    @Binding var shutter_speed: String
    @Binding var calculated_factor: Bool

    var reset: () -> Void

    var body: some View {
        VStack {
            Text("Priority Mode")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)

            VStack {
                HStack {
                    Button(action: {
                        self.priority_mode = .aperture
                        self.shutter_speed = ""

                        if (self.calculated_factor == true) {
                            reset()
                        }
                    }) {
                        Text("Aperture Priority")
                            .font(.system(.caption))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(self.priority_mode == .aperture ? .white : Color(hex: 0x434548))
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(self.priority_mode == .aperture ? Color(.systemBlue) : .clear)
                    .overlay(self.priority_mode == .aperture ? LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(4)
                    .shadow(color: Color(.systemBlue).opacity(self.priority_mode == .aperture ? 0.25 : 0), radius: 6, x: 0, y: 4)



                    Button(action: {
                        self.priority_mode = .shutter
                        self.aperture = ""

                        if (self.calculated_factor == true) {
                            reset()
                        }
                    }) {
                        Text("Shutter Priority")
                            .font(.system(.caption))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(self.priority_mode == .shutter ? .white : Color(hex: 0x434548))
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(self.priority_mode == .shutter ? Color(.systemBlue) : .clear)
                    .overlay(self.priority_mode == .shutter ? LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(4)
                    .shadow(color: Color(.systemBlue).opacity(self.priority_mode == .shutter ? 0.25 : 0), radius: 6, x: 0, y: 4)
                }
            }
            .padding(4)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.bottom, 10)
    }
}
