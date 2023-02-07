//
//  Feedback.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/28/22.
//

import SwiftUI

struct Feedback: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Hi, I'm [Tyler](https://reckart.blog). I run [Haptic Software](https://haptic.software) and develop FCalc without employees or outside funding. The quality and user experience of this app is extremely important to me. Whether you'd like to report issues to me directly or request new features, feedback is always welcome:")
                        .padding(.bottom)
                    
                    Text("[info@haptic.software](mailto:info@haptic.software)")
                        .padding(.bottom)
                    
                    Text("I try to read every message, but can't respond to them all.")
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text("Thank you for your feedback and understanding.")

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Send Feedback")
        .navigationBarTitleDisplayMode(.inline)
    }
}


