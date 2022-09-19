//
//  Subscription.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI
import StoreKit

struct SubscriptionTile: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var sub: Product

    @Binding var selectedOffer: Product?
    
    init(sub: Product, selectedOffer: Binding<Product?>) {
        self.sub = sub

        self._selectedOffer = selectedOffer
    }
    
    var body: some View {
        Button(action: {
            selectedOffer = sub
        }) {
            VStack {
                VStack {
                    Text(sub.displayName)
                        .font(.caption)
                        .foregroundColor(selectedOffer == sub ? Color.white.opacity(0.75) : Color(.systemGray))
                    Text("\(sub.displayPrice)")
                        .fontWeight(.medium)
                        .padding(.vertical, 5)
                        .foregroundColor(selectedOffer == sub ? .white : userAccentColor)
                    Text("Cancel anytime")
                        .font(.caption)
                        .foregroundColor(selectedOffer == sub ? Color.white.opacity(0.75) : Color(.systemGray))
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .padding()
            }
            .background(selectedOffer == sub ? userAccentColor : Color(.systemBackground))
            .overlay(LinearGradient(colors: [.white.opacity(selectedOffer == sub ? 0.2 : 0), .clear], startPoint: .top, endPoint: .bottom))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
        }
        .onAppear {
            if selectedOffer == nil && sub.id == "com.Aspen.plus.yearly" {
                selectedOffer = sub
            }
        }
    }
}

struct Pitch: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var store: Store
    
    @Binding var selectedOffer: Product?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Help show your support and fund the development of new features with an optional premium subscription.")
                .padding(.bottom)
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
                .background(Color(.systemGray))
                .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            if !store.subscriptions.isEmpty {
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
                            SubscriptionTile(sub: sub, selectedOffer: $selectedOffer)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

struct BuyButton: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var buy: () async -> Void

    var body: some View {
        Button(action: {
            Task {
                try? await buy()
            }
        }) {
            HStack {
                Spacer()
                Text("Join Now")
                    .fontWeight(.bold)
                Spacer()
            }
            .foregroundColor(Color(.white))
            .padding()
            .background(userAccentColor)
            .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
        }
    }
}

struct Subscription: View {
    var store: Store

    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    @State private var selectedOffer: Product?
    @State private var hasPurchased: Bool = false

    @State private var showManageSubscriptions: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack {
                    HStack(alignment: .top) {
                        Text("Aspen")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.trailing, -5)
                        Image(systemName: "plus.app")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(userAccentColor)
                            .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                    }
                    .padding(.top)
                    .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                
                if !hasPurchased {
                    Pitch(store: store, selectedOffer: $selectedOffer)
                } else {
                    VStack {
                        Text("Thank you for supporting Aspen as a premium subscriber. Your contributions help fund new features and cover the costs of development.")
                            .padding(.bottom)
                    }
                    .padding(.horizontal)
                }

                VStack(spacing: 10) {
                    if !store.subscriptions.isEmpty {
                        if !hasPurchased {
                            BuyButton(buy: buy)
                        } else {
                            Button(action: {
                                Task {
                                    showManageSubscriptions.toggle()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Change or Cancel Subscription")
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                        }
                    }
                    
                    
                    Button(action: {
                        Task {
                            //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                            try? await AppStore.sync()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Restore Previous Purchases")
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
                
                VStack(spacing: 10) {
                    NavigationLink(destination: Terms()) {
                        HStack {
                            Spacer()
                            Text("Terms of Use")
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                    
                    NavigationLink(destination: Privacy()) {
                        HStack {
                            Spacer()
                            Text("Privacy Policy")
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                }
                .padding()
            }
        }
        .background(Color(.systemGray6))
        .manageSubscriptionsSheet(isPresented: $showManageSubscriptions)
        .onAppear {
            if !store.purchasedSubscriptions.isEmpty {
                hasPurchased = true
            }
        }
        .alert(isPresented: $showErrorAlert, error: ValidationError.NaN) {_ in
            Button(action: {
                showErrorAlert = false
            }) {
                Text("Ok")
            }
        } message: { error in
            Text(errorMessage ?? "Error. Please try again.")
        }
    }
    
    func buy() async {
        do {
            print(store)
            print(selectedOffer)
            print(store.subscriptions)
            if try await store.purchase(selectedOffer!) != nil {
                withAnimation {
                    hasPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            errorMessage = "Your purchase could not be verified by the App Store."
            showErrorAlert = true
        } catch {
            print("Failed purchase: \(error)")
        }
    }
}
