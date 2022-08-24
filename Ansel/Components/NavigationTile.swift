//
//  NavigationTile.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct NavigationTile: View {
    var tile: DashboardTile
    var isDisabled: Bool = false
    
    @Binding var isEditing: Bool
    @Binding var isDragging: Bool
    @Binding var shouldRemoveTile: Bool
    
    var onRemove: (_ id: String) -> Void
    
    @State private var xpos: CGFloat = 0
    @State private var ypos: CGFloat = 0

    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                
                if value.location.y > 500 {
                    shouldRemoveTile = true
                }
                
                if value.location.y < 500 && shouldRemoveTile == true {
                    shouldRemoveTile = false
                }

                xpos = value.translation.width
                ypos = value.translation.height
            }
            .onEnded { value in
                isDragging = false

                if value.location.y > 500 {
                    // Remove the tile from the dashboard
                    onRemove(tile.key)
                    shouldRemoveTile = false
                }
                
                ypos = 0
                xpos = 0
            }
    }

    var body: some View {
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
        .background(isDisabled ? Color(.systemGray4) : tile.background)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
        .rotationEffect(.degrees(isEditing ? 1.25 : 0))
        .animation(isEditing ? .easeInOut(duration: 0.15).repeatForever(autoreverses: true) : .default, value: isEditing)
        .offset(x: xpos, y: ypos)
        .animation(!shouldRemoveTile ? .easeInOut(duration: 0.25) : .default, value: ypos)
        .gesture(isEditing ? simpleDrag : nil)
    }
}

struct LinkedNavigationTile: View {
    var tile: DashboardTile
    var isDisabled: Bool = false

    @Binding var isEditing: Bool
    @Binding var isDragging: Bool
    @Binding var shouldRemoveTile: Bool
    
    var onRemoveTile: (_ id: String) -> Void

    var body: some View {
        NavigationLink(destination: AnyView(tile.destination)) {
            NavigationTile(
                tile: tile,
                isDisabled: isDisabled,
                isEditing: $isEditing,
                isDragging: $isDragging,
                shouldRemoveTile: $shouldRemoveTile,
                onRemove: onRemoveTile
            )
        }
    }
}
