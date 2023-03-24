//
//  Dashboard.swift
//  Factor
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI
import MapKit

struct ActionDialog: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    @ObservedObject var locationManager: LocationManager = LocationManager()

    var toggleDialog: () -> ()
    @Binding var showDialog: Bool

    @State private var locationAllowed: Bool = false
    
    @State private var place: IdentifiablePlace = IdentifiablePlace(lat: 37.334_900, long: 122.009_020)
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )
    
    @State private var noteText: String = ""
    @State private var calculated: Bool = false

    var body: some View {
        Dialog(content: {
            VStack(spacing: 20) {
                HStack(spacing: 2) {
                    Image(systemName: "clock")
                    Text(Date().formatted(.dateTime))
                }
                .bold()
                
                Map(coordinateRegion: $region, annotationItems: [place]) { place in
                    MapMarker(coordinate: place.location, tint: userAccentColor)
                }
                .frame(maxHeight: 120)
                .cornerRadius(8)
                
                VStack {
                    HStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 2) {
                            Image(systemName: "film")
                                .foregroundColor(userAccentColor)
                            Text("Film Stock")
                                .textCase(.uppercase)
                        }
                        .font(.system(size: 12, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack {
                                Text("Delta 100")
                                    .bold()
                                    .frame(minWidth: 60)
                                    .font(.system(size: 14, weight: .bold))
                                Image(systemName: "chevron.down")
                                    .bold()
                                    .font(.system(size: 12))
                            }
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .padding(.vertical, 10)
                            .foregroundColor(.primary)
                            .frame(height: 40)
                            .background(.regularMaterial)
                            .cornerRadius(6)
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 2) {
                            Image(systemName: "plus.forwardslash.minus")
                                .foregroundColor(userAccentColor)
                            Text("Push/Pull")
                                .textCase(.uppercase)
                        }
                        .font(.system(size: 12, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack {
                                Text("+1")
                                    .bold()
                                    .frame(minWidth: 30)
                                    .font(.system(size: 14, weight: .bold))
                                Image(systemName: "chevron.down")
                                    .bold()
                                    .font(.system(size: 12))
                            }
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .padding(.vertical, 10)
                            .frame(height: 40)
                            .foregroundColor(.primary)
                            .background(.regularMaterial)
                            .cornerRadius(6)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 2) {
                        Image(systemName: "note.text")
                            .foregroundColor(userAccentColor)
                        Text("Notes")
                            .textCase(.uppercase)
                    }
                    .font(.system(size: 12, weight: .bold))
                    
                    TextField("Add your thoughts...", text: $noteText)
                        .font(.system(size: 14))
                        .padding()
                        .frame(height: 60)
                        .background(.ultraThickMaterial)
                        .cornerRadius(8)
                }
            }
        }, calculatedContent: { EmptyView() }, open: $showDialog, calculated: $calculated)
    }
    
    func requestLocationAuthorization() {
        do {
            try locationManager.start()
        }
        catch {
            // handle the lack of authorization, e.g. by
            // locationProvider.requestAuthorization()
        }
    }
}

struct ActionButton: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    
    var action: () -> ()

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
    
                Button(action: action) {
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
                    .padding([.horizontal, .top])
                }
                
                ActionButton(action: { self.showActionDialog.toggle() })
                ActionDialog(toggleDialog: { self.showActionDialog.toggle() }, showDialog: $showActionDialog)
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
