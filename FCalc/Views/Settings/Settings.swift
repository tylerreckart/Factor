//
//  SettingsView.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/23/22.
//

import SwiftUI

struct Settings: View {
    var store: Store?

    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink(destination: FilmStocks()) {
                        Text("Film Stocks")
                    }
                }

                Section(header: Text("Customization").font(.system(size: 12))) {
                    NavigationLink(destination: ThemeSettings()) {
                        Text("Theme")
                    }
                }
                
                Section(header: Text("Feedback").font(.system(size: 12))) {
                    NavigationLink(destination: Feedback()) {
                        Text("Send Feedback")
                    }
                }
                
                Section {
                    NavigationLink(destination: Privacy()) {
                        Text("Privacy Policy")
                    }
                    NavigationLink(destination: About()) {
                        Text("About")
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
