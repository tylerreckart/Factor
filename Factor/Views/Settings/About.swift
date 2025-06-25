//
//  About.swift
//  Factor
//
//  Created by Tyler Reckart on 8/28/22.
//

import SwiftUI
import Foundation
import StoreKit

struct AboutContent: View {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    let icon = UIApplication.shared.icon

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image("DisplayAppIcon")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.top, 60)
                Text("Factor \(version)")
                    .font(.system(size: 24, weight: .bold))
                Text("Hi, I'm Tyler. I run Haptic Software, the development studio behind Factor, as a one-person shop without employees or outside funding.\n\nThis app would not be possible without the love and support of my wife, our kids, and our dog.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }) {
                    HStack {
                        ZStack {
                            Rectangle().fill(Color(.systemBlue)).frame(width: 32, height: 32).cornerRadius(10)
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .symbolRenderingMode(.hierarchical)
                        }
                        Text("Rate Factor on the App Store")
                        Spacer()
                    }
                }
                .foregroundColor(.primary)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Section {
                    VStack {
                        Link(destination: URL(string: "itms-apps://itunes.apple.com/app/id/6745360976")!) {
                            HStack {
                                Image("AlbumsAppIcon").resizable().frame(width: 32, height: 32).cornerRadius(10)
                                Text("Albums: Your Music Catalog")
                                Spacer()
                            }
                        }
                        Divider().padding(.vertical, 5)
                        Link(destination: URL(string: "itms-apps://itunes.apple.com/app/id/6745826724")!) {
                            HStack {
                                Image("SolarAppIcon").resizable().frame(width: 32, height: 32).cornerRadius(10)
                                Text("Solar: Sun Tracker & UV Forecast")
                                Spacer()
                            }
                        }
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                } header: {
                    HStack {
                        Text("Our Apps")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(.systemGray))
                            .textCase(nil)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.top)
                }
                .padding(.horizontal)
                
                Text("© 2025 Haptic Software LLC")
                    .font(.system(size: 12))
                    .padding(.vertical)
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color(.systemGray6))
    }
}

struct About: View {
    var body: some View {
        AboutContent()
            .background(Color(.systemGray6))
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
    }
}

