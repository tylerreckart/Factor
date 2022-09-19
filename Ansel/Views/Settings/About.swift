//
//  About.swift
//  Aspen
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
                            Image("aspen.fill")
                                .font(.system(size: 64))
                                .foregroundColor(Color(.systemGray4))
                                .padding(.bottom, 1)
                            
                            Text("Aspen 1.1")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                        }
                        Spacer()
                    }

                    Text("Hi, I'm [Tyler](https://reckart.blog). I run [Haptic Software](https://haptic.software) and develop Aspen without employees or outside funding.")
                        .padding(.bottom)
                    Text("This app would not be possible without the love and support of my wife, son, and our two dogs.")
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Aspen 1.1 (1)")
                            Text("© 2022 Haptic Software, LLC")
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

