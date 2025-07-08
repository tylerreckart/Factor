//
//  Dashboard.swift
//  Factor
//
//  Created by the Factor Contributors.
//

import SwiftUI

struct Dashboard: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    @State private var showActionDialog: Bool = false
    @State private var showReciprocityDialog: Bool = false
    @State private var showFilterDialog: Bool = false
    @State private var showBellowsDialog: Bool = false
    @State private var showLightMeter: Bool = false

    var body: some View {
        return NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Button(action: { self.showLightMeter.toggle() }) {
                                Tile(title: "Light Meter", iconName: "sun.horizon", color: Color(.systemYellow))
                            }
                            
                            Button(action: { self.showReciprocityDialog.toggle() }) {
                                Tile(title: "Reciprocity Failure", iconName: "stopwatch", color: Color(.systemGreen))
                            }
                        }
                        
                        HStack (spacing: 20) {
                            Button(action: { self.showFilterDialog.toggle() }) {
                                Tile(title: "Filter factor", iconName: "camera.filters", color: Color(.systemBlue))
                            }
                            
                            Button(action: { self.showBellowsDialog.toggle() }) {
                                Tile(title: "Bellows Extension Factor", iconName: "arrow.up.backward.and.arrow.down.forward.circle.fill", color: Color(.systemPurple))                            }
                        }
                        
                        HStack(spacing: 20) {
                            NavigationLink(destination: Settings()) {
                                Tile(title: "Settings", iconName: "gear", color: Color(.systemGray))
                            }
                            Color.clear
                        }
                    }
                    .padding([.horizontal, .top])
                }
                
                // ActionDialog(toggleDialog: { self.showActionDialog.toggle() }, showDialog: $showActionDialog)
                Reciprocity(open: $showReciprocityDialog)
                FilterFactor(open: $showFilterDialog)
                BellowsExtension(open: $showBellowsDialog)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "camera.filters")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.accentColor)
                        Text("Factor")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .zIndex(1)
                    Spacer()
                }
            }
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $showLightMeter) {
                LightMeterView()
            }
        }
    }
}
