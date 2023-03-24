//
//  Dashboard.swift
//  Factor
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct Dashboard: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    @State private var showActionDialog: Bool = false
    @State private var showReciprocityDialog: Bool = false
    @State private var showFilterDialog: Bool = false
    @State private var showBellowsDialog: Bool = false

    var body: some View {
        return NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Button(action: { self.showReciprocityDialog.toggle() }) {
                            SimpleTile(tile: {
                                DashboardTile(
                                    key: "reciprocity_factor",
                                    label: "Reciprocity Factor",
                                    icon: "stopwatch",
                                    background: Color(.systemPurple)
                                )
                            }())
                        }
                        
                        Button(action: { self.showFilterDialog.toggle() }) {
                            SimpleTile(tile: {
                                DashboardTile(
                                    key: "filter_factor",
                                    label: "Filter Factor",
                                    icon: "camera.filters",
                                    background: Color(.systemPink)
                                )
                            }())
                        }
                        
                        Button(action: { self.showBellowsDialog.toggle() }) {
                            SimpleTile(tile: {
                                DashboardTile(
                                    key: "bellows_extension_factor",
                                    label: "Bellows Extension Factor",
                                    icon: "arrow.up.backward.and.arrow.down.forward.circle.fill",
                                    background: Color(.systemBlue)
                                )
                            }())
                        }
                    }
                    .padding([.horizontal, .top])
                    
//                    VStack(spacing: 20) {
//                        HStack {
//                            Text("Exposure Log")
//                                .font(.system(size: 16, weight: .bold))
//                            Spacer()
//                        }
//                        .padding(.horizontal)
//                        .padding(.bottom, -10)
//
//                        Text("Logged exposures will appear here.")
//                            .font(.system(size: 16, weight: .regular))
//                            .foregroundColor(Color.gray)
//                            .italic()
//                            .padding()
//                            .padding(.vertical, 15)
//                            .frame(maxWidth: .infinity)
//                            .background(Color(.systemGray5))
//                            .cornerRadius(16)
//                    }
//                    .padding([.horizontal, .top])
                }
                
//                ActionButton(action: { self.showActionDialog.toggle() })
//                ActionDialog(toggleDialog: { self.showActionDialog.toggle() }, showDialog: $showActionDialog)
                Reciprocity(open: $showReciprocityDialog)
                FilterFactor(open: $showFilterDialog)
                BellowsExtension(open: $showBellowsDialog)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "camera.filters")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.accentColor)
                        Text("Factor")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .zIndex(1)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .zIndex(1)
                }
            }
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
