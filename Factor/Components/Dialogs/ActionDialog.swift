//
//  ActionDialog.swift
//  Factor
//
//  Created by Tyler Reckart on 3/24/23.
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
