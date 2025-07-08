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
                Text("Factor is an open-source photography app designed for film photographers who need precise exposure calculations under challenging conditions.\n\nBuilt with SwiftUI for iOS, Factor combines a real-time light meter with sophisticated calculators for common exposure problems.")
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
                        Link(destination: URL(string: "https://github.com/yourusername/factor")!) {
                            HStack {
                                Image(systemName: "chevron.left.forwardslash.chevron.right")
                                    .foregroundColor(.blue)
                                    .frame(width: 32, height: 32)
                                Text("View Source Code")
                                Spacer()
                            }
                        }
                        Divider().padding(.vertical, 5)
                        Link(destination: URL(string: "https://github.com/yourusername/factor/issues")!) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.orange)
                                    .frame(width: 32, height: 32)
                                Text("Report Issues")
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
                        Text("Open Source")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(.systemGray))
                            .textCase(nil)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.top)
                }
                .padding(.horizontal)
                
                Text("© 2025 Factor Contributors")
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

