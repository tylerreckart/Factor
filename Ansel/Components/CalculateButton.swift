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
            Text("Calculate")
                .font(.system(.body))
                .fontWeight(.bold)
                .foregroundColor(
                    !isDisabled ? .white : Color(.systemGray3)
                )
                .padding(14)
                .frame(maxWidth: .infinity)
                .background(isDisabled ? Color(.systemGray6) : .accentColor)
                .overlay(
                    LinearGradient(colors: [
                        !useDarkMode && !isDisabled
                            ? .white.opacity(0.2)
                            : .white.opacity(0.05), .clear
                    ], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(4)
        }
    }
}
