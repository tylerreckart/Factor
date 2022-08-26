//
//  SettingsView.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/23/22.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: ThemeSettings()) {
                    Text("Theme")
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
