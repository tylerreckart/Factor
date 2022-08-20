//
//  CalculateButton.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct CalculateButton: View {
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
        }
        .foregroundColor(isDisabled ? Color(.systemGray2) : .white)
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(isDisabled ? Color(.systemGray5) : Color(.systemBlue))
        .cornerRadius(4)
    }
}
