//
//  CalculateButton.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct CalculateButton: View {
    var calculate: () -> Void
    
    var body: some View {
        Button(action: calculate) {
            Text("Calculate")
                .font(.system(.body))
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .padding(14)
        .frame(maxWidth: 180)
        .background(Color(.systemBlue))
        .cornerRadius(24)
        .shadow(color: Color(.systemBlue).opacity(0.25), radius: 6, x: 0, y: 4)
    }
}
