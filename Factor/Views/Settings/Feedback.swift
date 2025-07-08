//
//  Feedback.swift
//  Factor
//
//  Created by Tyler Reckart on 8/28/22.
//

import SwiftUI

struct Feedback: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Factor is an open-source project developed by the community. We welcome feedback, bug reports, and feature requests. Here's how you can contribute:")
                        .padding(.bottom)
                    
                    Text("**GitHub Issues**: [Report bugs and request features](https://github.com/yourusername/factor/issues)")
                        .padding(.bottom)
                    
                    Text("**Pull Requests**: [Contribute code improvements](https://github.com/yourusername/factor/pulls)")
                        .padding(.bottom)
                    
                    Text("**Discussions**: [Join community discussions](https://github.com/yourusername/factor/discussions)")
                        .padding(.bottom)
                    
                    Text("Thank you for helping make Factor better for everyone!")

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Contribute")
        .navigationBarTitleDisplayMode(.inline)
    }
}


