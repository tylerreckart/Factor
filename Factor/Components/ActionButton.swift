//
//  ActionButton.swift
//  Factor
//
//  Created by Tyler Reckart on 3/24/23.
//

import Foundation
import SwiftUI

struct ActionButton: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    
    var action: () -> ()

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
    
                Button(action: action) {
                    Image(systemName: "pencil")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                        .background(userAccentColor.overlay(LinearGradient(colors: [.white.opacity(0.25), .clear], startPoint: .top, endPoint: .bottom)))
                        .cornerRadius(.infinity)
                        .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
                }
                .padding(.bottom, 25)
                .padding(.trailing, 25)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
