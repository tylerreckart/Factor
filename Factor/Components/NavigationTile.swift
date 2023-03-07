//
//  NavigationTile.swift
//  Factor
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct SimpleTile: View {
    @AppStorage("overrideDefaultUIColors") var overrideDefaultColors: Bool = false
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var tile: DashboardTile
    var isDisabled: Bool = false
    
    @State private var animate: Bool = false

    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: tile.icon)
                    .font(.system(size: 16, weight: .bold))
                Text(tile.label)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
            .padding()
            .foregroundColor(isDisabled ? Color(.systemGray) : .white)
            .background(overrideDefaultColors && !isDisabled ? userAccentColor : isDisabled ? Color(.systemGray4) : tile.background)
            .overlay(LinearGradient(colors: [.white.opacity(0.25), .clear], startPoint: .top, endPoint: .bottom))
            .cornerRadius(16)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

struct LinkedNavigationTile: View {
    var tile: DashboardTile
    var isDisabled: Bool = false
    
    var url: String
    
    @State private var shouldNavigate: Bool = false
    
    var changeNavState: Bool = false
    
    init(
        tile: DashboardTile,
        isDisabled: Bool,
        url: String,
        shouldNavigate: Bool
    ) {
        self.tile = tile
        self.isDisabled = isDisabled
        self.url = url
        self.shouldNavigate = shouldNavigate
        
        if url == tile.url {
            changeNavState = true
        } else {
            self.shouldNavigate = shouldNavigate
        }
    }

    var body: some View {
        NavigationLink(destination: AnyView(tile.destination), isActive: $shouldNavigate) {
            SimpleTile(tile: tile)
        }
        .onChange(of: changeNavState) { newState in
            shouldNavigate = newState
        }
    }
}
