//
//  Dashboard.swift
//  FCalc
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
                        url: "FCalc://reciprocityFactor"
                    ),
                    isDisabled: false,
                    url: "FCalc://reciprocityFactor",
                    shouldNavigate: false
                )
                
                LinkedNavigationTile(
                    tile: DashboardTile(
                        key: "filter_factor",
                        label: "Filter Factor",
                        icon: "camera.filters",
                        background: Color(.systemPink),
                        destination: AnyView(FilterFactor()),
                        url: "FCalc://filterFactor"
                    ),
                    isDisabled: false,
                    url: "FCalc://filterFactor",
                    shouldNavigate: false
                )

                LinkedNavigationTile(
                    tile: DashboardTile(
                        key: "bellows_extension_factor",
                        label: "Bellows Extension Factor",
                        icon: "arrow.up.backward.and.arrow.down.forward.circle.fill",
                        background: Color(.systemBlue),
                        destination: AnyView(BellowsExtension()),
                        url: "FCalc://bellowsExtension"
                    ),
                    isDisabled: false,
                    url: "FCalc://bellowsExtension",
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
                        Text("FCalc")
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
