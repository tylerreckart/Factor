//
//  Modifiers.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI

public struct PlaceholderStyle: ViewModifier {
    @Binding var text: String
    @Binding var focused: Bool

    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            content

            if text.isEmpty {
                Text(placeholder)
                    .padding(.horizontal, 15)
                    .foregroundColor(Color(hex: 0x6d6e73))
            }
            
            if !text.isEmpty {
                HStack {
                    Spacer()
                    Button(
                        action: { self.text = "" },
                        label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(hex: 0xa4a9ab))
                                .padding(.trailing, 14)
                        }
                    )
                }
            }
        }
    }
}
