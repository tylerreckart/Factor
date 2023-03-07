//
//  Dashboard.swift
//  Factor
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct Dashboard: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    
    @State private var layout: [DashboardTile] = []

    var url: String?
    var store: Store?

    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        return NavigationView {
            VStack(spacing: 20) {
                LinkedNavigationTile(
                    tile: DashboardTile(
                        key: "reciprocity_factor",
                        label: "Reciprocity Factor",
                        icon: "stopwatch",
                        background: Color(.systemPurple),
                        destination: AnyView(Reciprocity()),
                        url: "Factor://reciprocityFactor"
                    ),
                    isDisabled: false,
                    url: "Factor://reciprocityFactor",
                    shouldNavigate: false
                )
                
                LinkedNavigationTile(
                    tile: DashboardTile(
                        key: "filter_factor",
                        label: "Filter Factor",
                        icon: "camera.filters",
                        background: Color(.systemPink),
                        destination: AnyView(FilterFactor()),
                        url: "Factor://filterFactor"
                    ),
                    isDisabled: false,
                    url: "Factor://filterFactor",
                    shouldNavigate: false
                )

                LinkedNavigationTile(
                    tile: DashboardTile(
                        key: "bellows_extension_factor",
                        label: "Bellows Extension Factor",
                        icon: "arrow.up.backward.and.arrow.down.forward.circle.fill",
                        background: Color(.systemBlue),
                        destination: AnyView(BellowsExtension()),
                        url: "Factor://bellowsExtension"
                    ),
                    isDisabled: false,
                    url: "Factor://bellowsExtension",
                    shouldNavigate: false
                )

                Spacer()
            }
            .padding()
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
                    NavigationLink(destination: Settings(store: store)) {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .background(useDarkMode ? Color(.black) : Color(.systemGray6))
        }
    }
}
