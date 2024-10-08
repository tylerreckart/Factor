//
//  CalculatedResultCard.swift
//  Factor
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct CalculatedResultCard: View {
    @AppStorage("overrideDefaultUIColors") var overrideDefaultColors: Bool = false

    var label: String
    var icon: String
    var result: String
    var background: Color
    var foreground: Color = .white

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
                    .font(.system(.title))
            }
            .foregroundColor(foreground)
            .frame(height: 125, alignment: .topLeading)
            .padding()
            .background(overrideDefaultColors ? .accentColor : background)
            .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
        }
    }
}

