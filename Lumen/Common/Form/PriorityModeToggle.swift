//
//  PriorityModeToggle.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI

struct PriorityModeToggle: View {
    @Binding var priority_mode: String
    @Binding var aperture: String
    @Binding var shutter_speed: String
    @Binding var calculated_factor: Bool

    var reset: () -> Void

    var body: some View {
        VStack {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray6))
                .frame(width: self.priority_mode == "aperture" ? 300 : 300, height: 38)
                .position(x: self.priority_mode == "aperture" ? 176 : 150, y: 43.25)

            VStack {
                Text("Mode")
                    .font(.system(.caption))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
        
                HStack {
                    Button(action: {
                        self.priority_mode = "aperture"
                        self.shutter_speed = ""

                        if (self.calculated_factor == true) {
                            reset()
                        }
                    }) {
                        Text("Aperture Priority")
                            .font(.system(.caption))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(self.priority_mode == "aperture" ? .white : Color(hex: 0x434548))
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(self.priority_mode == "aperture" ? Color(.systemBlue) : .clear)
                    .cornerRadius(18)
                    .shadow(color: self.priority_mode == "aperture" ? Color(.systemBlue).opacity(0.25) : .clear, radius: 6, x: 0, y: 4)



                    Button(action: {
                        self.priority_mode = "shutter"
                        self.aperture = ""

                        if (self.calculated_factor == true) {
                            reset()
                        }
                    }) {
                        Text("Shutter Priority")
                            .font(.system(.caption))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(self.priority_mode == "shutter" ? .white : Color(hex: 0x434548))
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(self.priority_mode == "shutter" ? Color(.systemBlue) : .clear)
                    .cornerRadius(18)
                    .shadow(color: self.priority_mode == "shutter" ? Color(.systemBlue).opacity(0.25) : .clear, radius: 6, x: 0, y: 4)
                }
            }
            }
        }
    }
}
