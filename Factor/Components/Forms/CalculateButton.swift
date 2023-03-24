//
//  CalculateButton.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct CalculateButton: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    var calculate: () -> Void
    var isDisabled: Bool = false
    
    func onPress() -> Void {
        if isDisabled {
            return
        }
        
        calculate()
    }
    
    var body: some View {
        Button(action: onPress) {
            if (isDisabled) {
                Text("Calculate")
                    .font(.system(.body))
                    .fontWeight(.bold)
                    .foregroundColor(
                        !isDisabled ? .white : Color(.systemGray)
                    )
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .cornerRadius(8)
            } else {
                Text("Calculate")
                    .font(.system(.body))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBlue))
                    .overlay(
                        LinearGradient(colors: [
                            !useDarkMode
                                ? .white.opacity(0.2)
                                : .clear, .clear
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(8)
            }
        }
    }
}
