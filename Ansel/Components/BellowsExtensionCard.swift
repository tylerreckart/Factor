//
//  BellowsExtensionCard.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/17/22.
//

import SwiftUI

struct CompensationFactorCard: View {
    var label: String
    var icon: String
    var result: String
    var background: Color
    var foreground: Color = .white
    
    @State var xpos: CGFloat = 94
    @State var ypos: CGFloat = 1000
    
    var delay: CGFloat = 0

    var body: some View {
        VStack {
            VStack {
                Image(systemName: icon)
                    .imageScale(.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text(label)
                    .font(.system(.caption))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Spacer()
                Text(result)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(.title, design: .rounded))
            }
            .foregroundColor(foreground)
            .frame(height: 125, alignment: .topLeading)
            .padding()
            .background(background)
            .cornerRadius(18)
            .position(x: xpos, y: ypos)
            .animation(.easeInOut(duration: 0.5 + delay), value: ypos)
        }
        .onAppear {
            ypos = 80 // Trigger the animation to start
        }
    }
}
