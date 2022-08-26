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
                Section(header: Text("Customization")) {
                    NavigationLink(destination: ThemeSettings()) {
                        Text("Theme")
                    }
                    NavigationLink(destination: AppIconSettings()) {
                        Text("App Icon")
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
