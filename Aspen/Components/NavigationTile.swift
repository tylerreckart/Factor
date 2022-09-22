//
//  NavigationTile.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct MinusButton: View {
    var tileId: String
    var removeTile: (String) -> Void

    let screenWidth = UIScreen.main.bounds.width
    
    @State private var presentAlert: Bool = false

    var body: some View {
        Button(action: {
            self.presentAlert.toggle()
        }) {
            Image(systemName: "minus")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.systemGray))
                .frame(width: 25, height: 25)
                .background(.ultraThinMaterial)
                .cornerRadius(.infinity)
                .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)
        }
        .offset(x: (screenWidth / 2) - 20, y: -55)
        .confirmationDialog("Remove Tile", isPresented: $presentAlert) {
            Button("Remove", role: .destructive) {
                removeTile(tileId)
            }
        } message: {
            Text("Remove this tile from your dashboard?")
          }
    }
}

struct SimpleTile: View {
    @AppStorage("overrideDefaultUIColors") var overrideDefaultColors: Bool = false
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var tile: DashboardTile
    var isDisabled: Bool = false

    @Binding var isEditing: Bool
    
    @State private var animate: Bool = false
    
    var removeTile: (String) -> Void

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Image(systemName: tile.icon)
                    .imageScale(.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text(tile.label)
                    .font(.system(.body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            .padding()
            .foregroundColor(isDisabled ? Color(.systemGray) : .white)
            .background(overrideDefaultColors && !isDisabled ? userAccentColor : isDisabled ? Color(.systemGray4) : tile.background)
            .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
            .cornerRadius(18)
            .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            
            if isEditing {
                MinusButton(tileId: tile.id, removeTile: removeTile)
            } else {
                EmptyView()
            }
        }
        .onChange(of: isEditing) { newState in
            if isEditing {
                animate = true
            } else {
                animate = false
            }
        }
        .onAppear {
            if isEditing {
                animate = true
            }
        }
        .rotationEffect(.degrees(animate ? 1.25 : 0))
        .animation(animate ? .easeInOut(duration: 0.2).repeatForever(autoreverses: true) : .default, value: animate)
    }
}

struct LinkedNavigationTile: View {
    var tile: DashboardTile
    var isDisabled: Bool = false

    @Binding var draggingTile: DashboardTile?
    @Binding var isEditing: Bool
    
    var removeTile: (String) -> Void
    
    var url: String
    
    @State private var shouldNavigate: Bool = false
    
    var changeNavState: Bool = false
    
    init(
        tile: DashboardTile,
        isDisabled: Bool,
        draggingTile: Binding<DashboardTile?>,
        isEditing: Binding<Bool>,
        removeTile: @escaping (String) -> Void,
        url: String,
        shouldNavigate: Bool
    ) {
        self.tile = tile
        self.isDisabled = isDisabled
        self._draggingTile = draggingTile
        self._isEditing = isEditing
        self.removeTile = removeTile
        self.url = url
        self.shouldNavigate = shouldNavigate
        
        if url == tile.url {
            changeNavState = true
        } else {
            self.shouldNavigate = shouldNavigate
        }
    }

    var body: some View {
        if !isEditing {
            NavigationLink(destination: AnyView(tile.destination), isActive: $shouldNavigate) {
                SimpleTile(tile: tile, isEditing: $isEditing, removeTile: removeTile)
            }
            .onChange(of: changeNavState) { newState in
                shouldNavigate = newState
            }
        } else {
            SimpleTile(tile: tile, isEditing: $isEditing, removeTile: removeTile)
        }
    }
}
