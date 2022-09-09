//
//  Subscription.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI
import StoreKit

struct Subscription: View {
    @StateObject var store: Store = Store()

    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    
    @State private var selectedOffer: Product?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack {
                    HStack(alignment: .top) {
                        Text("Ansel")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.trailing, -5)
                        Image(systemName: "plus.app")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(userAccentColor)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                VStack {
                    Text("Help show your support and fund the development of new features with an optional premium subscription.")
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .padding(.horizontal)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Early Access to New Features")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                            .foregroundColor(Color(.white))
                        Text("Premium subscribers get early access to new features and priority support.")
                            .foregroundColor(Color(.white))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(userAccentColor)
                    .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("Choose a Plan")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack(spacing: 20) {
                        ForEach(store.subscriptions) { sub in
                            Button(action: {
                                selectedOffer = sub
                            }) {
                                VStack {
                                    VStack {
                                        Text(sub.displayName)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        Text("\(sub.displayPrice)/mo")
                                            .fontWeight(.medium)
                                            .padding(.vertical, 5)
                                        Text("Cancel anytime")
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                    }
                                    .frame(width: 120)
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(11)
                                }
                                .padding(1)
                                .background(selectedOffer == sub ? userAccentColor : .clear)
                                .cornerRadius(12)
                                .shadow(color: userAccentColor.opacity(selectedOffer == sub ? 0.2 : 0), radius: 12, x: 0, y: 10)
                            }
                        }
                    }
                    .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        
                        Button(action: {
                            Task {
                                //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                                try? await buy()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Join Now")
//                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                        
                        
                        Button(action: {
                            Task {
                                //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                                try? await AppStore.sync()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Restore Previous Purchases")
//                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    VStack {
                        Text("Payment for your subscription will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period.")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                            .padding(.bottom, 10)
                            .padding(.horizontal)
                        Text("You can manage and cancel your subscriptions by got to your account settings in the App Store after purchase.")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color(.systemGray6))
    }
    
    func buy() async {
        do {
            if try await store.purchase(selectedOffer!) != nil {
                withAnimation {
//                    isPurchased = true
                }
            }
        } catch StoreError.failedVerification {
//            errorTitle = "Your purchase could not be verified by the App Store."
//            isShowingError = true
        } catch {
            print("Failed purchase: \(error)")
        }
    }
}
