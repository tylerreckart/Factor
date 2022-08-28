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
        NavigationView {
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
            }
        }
        .navigationTitle("Ansel Premium")
        .navigationBarTitleDisplayMode(.inline)
    }
}
