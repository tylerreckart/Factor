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
                Section {
                    NavigationLink(destination: FilmStocks()) {
                        Text("Film Stocks")
                    }
                    NavigationLink(destination: Cameras()) {
                        Text("Cameras")
                    }
                    NavigationLink(destination: Lenses()) {
                        Text("Lenses")
                    }
                }

                Section(header: Text("Customization").font(.system(size: 12))) {
                    NavigationLink(destination: ThemeSettings()) {
                        Text("Theme")
                    }
                    NavigationLink(destination: AppIconSettings()) {
                        Text("App Icon")
                    }
                }
                
                Section(header: Text("Feedback").font(.system(size: 12))) {
                    NavigationLink(destination: Feedback()) {
                        Text("Send Feedback")
                    }
                    // TODO: Insert App Store link for direct rating.
//                    NavigationLink(destination: EmptyView()) {
//                        VStack(alignment: .leading) {
//                            Text("Please Rate Ansel")
//                                .padding(.bottom, 1)
//                            Text("Thank you for your support")
//                                .font(.system(size: 12))
//                                .textCase(.uppercase)
//                                .foregroundColor(Color(.systemGray))
//                        }
//                    }
                }
                
                Section {
                    NavigationLink(destination: Privacy()) {
                        Text("Privacy")
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
