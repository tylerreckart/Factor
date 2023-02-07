//
//  About.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/28/22.
//

import SwiftUI

struct About: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        VStack {
                            Text("FCalc 2.0")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                        }
                        Spacer()
                    }

                    Text("Hi, I'm [Tyler](https://reckart.blog). I run [Haptic Software](https://haptic.software) and develop FCalc without employees or outside funding.")
                        .padding(.bottom)
                    Text("This app would not be possible without the love and support of my wife, son, and our two dogs.")
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("FCalc 2.0 (1)")
                            Text("© 2023 Haptic Software, LLC")
                            Text("Made in South Carolina")
                        }
                        .foregroundColor(Color(.systemGray))
                        Spacer()
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

