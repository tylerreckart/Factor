//
//  NavigationTile.swift
//  Factor
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct Tile: View {
    @AppStorage("overrideDefaultUIColors") var overrideDefaultColors: Bool = false
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var title: String
    var iconName: String
    var color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(color)
                .padding(.bottom, 4) // Small space after icon before text

            Text(title)
                .font(.system(size: 18, weight: .semibold)) // Standard font for tile titles
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(2) // Allow title to wrap to two lines if necessary
                .minimumScaleFactor(0.8) // Allow text to shrink slightly to fit
            Spacer()
        }
        .padding() // Padding inside the tile
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // VStack content leading aligned
        .frame(height: 120) // A fixed height for uniform tiles; use minHeight for dynamic content
        .background(Color(.systemBackground))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.systemGray5), lineWidth: 4)
        }
        .cornerRadius(16) // Common iOS corner radius for card-like elements
    }
}
