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
        Picker("Priority Mode", selection: $priority_mode) {
            ForEach(PriorityMode.allCases) { mode in
                    Text(mode.rawValue.capitalized)
                }
        }
        .pickerStyle(.segmented)
    }
}
