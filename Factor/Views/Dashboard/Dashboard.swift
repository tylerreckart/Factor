//
//  Dashboard.swift
//  Factor
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct ActionButton: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
    
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                        .background(userAccentColor.overlay(LinearGradient(colors: [.white.opacity(0.25), .clear], startPoint: .top, endPoint: .bottom)))
                        .cornerRadius(.infinity)
                        .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
                }
                .padding(.bottom, 25)
                .padding(.trailing, 25)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Dashboard: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    
    @State private var layout: [DashboardTile] = []

    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        return NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        LinkedNavigationTile(
                            tile: DashboardTile(
                                key: "reciprocity_factor",
                                label: "Reciprocity Factor",
                                icon: "stopwatch",
                                background: Color(.systemPurple),
                                destination: AnyView(Reciprocity())
                            ),
                            isDisabled: false
                        )
                        
                        LinkedNavigationTile(
                            tile: DashboardTile(
                                key: "filter_factor",
                                label: "Filter Factor",
                                icon: "camera.filters",
                                background: Color(.systemPink),
                                destination: AnyView(FilterFactor())
                            ),
                            isDisabled: false
                        )
                        
                        LinkedNavigationTile(
                            tile: DashboardTile(
                                key: "bellows_extension_factor",
                                label: "Bellows Extension Factor",
                                icon: "arrow.up.backward.and.arrow.down.forward.circle.fill",
                                background: Color(.systemBlue),
                                destination: AnyView(BellowsExtension())
                            ),
                            isDisabled: false
                        )
                        
                        Spacer()
                    }
                    .padding([.horizontal, .top])
                    
                    VStack(spacing: 20) {
                        HStack {
                            Text("Exposure Log")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, -10)
                            
                        Text("Logged exposures will appear here.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color.gray)
                            .italic()
                            .padding()
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                
                ActionButton()
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
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .background(useDarkMode ? Color(.black) : Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
