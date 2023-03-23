//
//  Dashboard.swift
//  Factor
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI
import MapKit

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

struct ActionDialog: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    @ObservedObject var locationManager: LocationManager = LocationManager()

    var toggleDialog: () -> ()
    @Binding var showDialog: Bool
    
    @State private var showDialogBody: Bool = false
    @State private var showOverlay: Bool = false
    @State private var locationAllowed: Bool = false
    
    @State private var place: IdentifiablePlace = IdentifiablePlace(lat: 37.334_900, long: 122.009_020)
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )
    
    @State private var noteText: String = ""

    var body: some View {
        ZStack {
            if (showOverlay) {
                Color.black.opacity(0.2)
                    .transition(.opacity)
                    .onTapGesture {
                        toggleDialog()
                    }
            }
            
            if (showDialogBody) {
                VStack {
                    Spacer()
                    VStack {
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
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .transition(.scale(scale: 0.4).combined(with: .opacity))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .zIndex(2)
        .onChange(of: showDialog) { newState in
            if (locationManager.authorizationStatus == .authorizedWhenInUse) {
                if (newState == true) {
                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.4, blendDuration: 1)) {
                        self.showDialogBody = newState
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.showDialogBody = newState
                    }
                }
                
                withAnimation {
                    self.showOverlay = newState
                }
                
                let lat = locationManager.location?.coordinate.latitude ?? 37.334_900
                let lon = locationManager.location?.coordinate.longitude ?? -122.009_020
                
                self.region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: lon
                        ),
                        latitudinalMeters: 750,
                        longitudinalMeters: 750
                    )
                
                self.place = IdentifiablePlace(lat: lat, long: lon)
            } else {
                requestLocationAuthorization()
            }
        }
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
                
                ActionButton(action: { self.showActionDialog.toggle() })
                ActionDialog(toggleDialog: { self.showActionDialog.toggle() }, showDialog: $showActionDialog)
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
                    .opacity(self.showActionDialog ? 0.7 : 1)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .zIndex(1)
                    .opacity(self.showActionDialog ? 0.7 : 1)
                    .disabled(self.showActionDialog)
                }
            }
            .background(useDarkMode ? Color(.black) : Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
