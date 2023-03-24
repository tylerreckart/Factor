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

    @State private var showHapticSheet: Bool = false
    @State private var showSpindownSheet: Bool = false
    @State private var showDeveloperSheet: Bool = false
    
    let icon = UIApplication.shared.icon

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image(systemName: "camera.filters")
                    .font(.system(size: 64, weight: .regular))
                    .foregroundColor(.accentColor)
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
                    .padding(.top, 20)
                Text("Factor \(version)")
                    .font(.system(size: 24, weight: .bold))
                Text("Hi, I'm Tyler. I run Haptic, the development studio behind Factor, as a one-person shop without employees or outside funding.\n\nThis app would not be possible without the love and support of my family and our two dogs.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                List {
                    Section(header:
                                Text("Follow Us")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(.systemGray))
                    ) {
                        Button(action: {
                            self.showHapticSheet.toggle()
                        }) {
                            HStack(alignment: .center) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.black)
                                        .frame(width: 30, height: 30)
                                    Image("HapticLogo")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Haptic")
                                    Text("Company News and Updates")
                                        .font(.caption)
                                }
                            }
                            .frame(height: 40)
                        }
                        
                        
                        Button(action: {
                            self.showSpindownSheet.toggle()
                        }) {
                            HStack(alignment: .center) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.blue)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "camera.filters")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .bold))
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Factor")
                                    Text("App Updates and Feedback")
                                        .font(.caption)
                                }
                            }
                            .frame(height: 40)
                        }
                        
                        Button(action: {
                            self.showDeveloperSheet.toggle()
                        }) {
                            HStack(alignment: .center) {
                                Image("ProfilePhoto")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                                
                                VStack(alignment: .leading) {
                                    Text("Tyler Reckart")
                                    Text("Developer")
                                        .font(.caption)
                                }
                            }
                            .frame(height: 40)
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Section {
                        Button(action: {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }) {
                            Text("Rate Spindown on the App Store")
                        }
                    }
                    .foregroundColor(.accentColor)
                }
                .frame(height: 325)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .listStyle(InsetGroupedListStyle())
                
                Text("© 2023 Haptic Software LLC. Factor \(version)")
                    .font(.system(size: 12))
                    .padding(.bottom)
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color(.systemGray6))
        .sheet(isPresented: $showHapticSheet) {
            WebView(url: URL(string: "https://mastodon.social/@haptic")!)
        }
        .sheet(isPresented: $showSpindownSheet) {
            WebView(url: URL(string: "https://mastodon.social/@factor")!)
        }
        .sheet(isPresented: $showDeveloperSheet) {
            WebView(url: URL(string: "https://mastodon.social/@tyler")!)
        }
    }
}

struct About: View {
    var body: some View {
        NavigationView {
            AboutContent()
                .background(Color(.systemGray6))
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

