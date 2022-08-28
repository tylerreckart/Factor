//
//  Premium.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/28/22.
//

import SwiftUI

struct Premium: View {
    @State private var isPremium: Bool = false

    var body: some View {
        List {
            Section(header:
                VStack(alignment: .leading) {
                    if isPremium {
                        Text("Thank you for supporting Ansel as a premium customer.")
                            .padding(.bottom)
                    }
                    
                    Text("Ansel Premium is an optional subscription that shows your support and funds future development. There are no additional features available to premium subscribers. Ansel's core feature set is and will always remain free to use.")
                }
                .padding(.bottom)
                .foregroundColor(Color(.systemGray))
                .font(.system(size: 14))
                .textCase(.none)
            ) {
                if isPremium {
                    Text("Change or Cancel Subscription")
                } else {
                    Text("Subscribe for $9.99 per year")
                }
                
                Text("Restore Previous Purchases")
            }
            
            Section(header:
                VStack(alignment: .leading) {
                    Text("Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period.")
                        .padding(.bottom)
                    Text("You can manage and cancel your subscription by going to your account settigns in the App Store after purchase.")
                }
                .padding(.bottom)
                .foregroundColor(Color(.systemGray))
                .font(.system(size: 14))
                .textCase(.none)
            ) {
                NavigationLink(destination: Privacy()) {
                    Text("Privacy Policy")
                }
                
                NavigationLink(destination: EmptyView()) {
                    Text("Terms of Use")
                }
            }
        }
        .navigationTitle("Ansel Premium")
        .navigationBarTitleDisplayMode(.inline)
    }
}
