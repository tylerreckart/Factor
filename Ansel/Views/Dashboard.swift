//
//  Dashboard.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct Dashboard: View {
    @Binding var isDrawerOpen: Bool
    @Binding var isDragging: Bool
    @Binding var shouldRemoveTile: Bool

    @State private var isEditing: Bool = false
    // TODO: Remove the stateful nature of this layout behavior. Should persist between sessions.
    @State private var layout = [
        DashboardTile(
            key: "notes",
            label: "Notes",
            icon: "bookmark.circle.fill",
            background: Color(.systemYellow),
            destination: AnyView(Notes())
        ),
        DashboardTile(
            key: "reciprocity_factor",
            label: "Reciprocity Factor",
            icon: "bookmark.circle.fill",
            background: Color(.systemPurple),
            destination: AnyView(Reciprocity())
        ),
        DashboardTile(
            key: "bellows_extension_factor",
            label: "Bellows Extension Factor",
            icon: "bookmark.circle.fill",
            background: Color(.systemBlue),
            destination: AnyView(BellowsExtension())
        ),
        DashboardTile(
            key: "filter_factor",
            label: "Filter Factor",
            icon: "bookmark.circle.fill",
            background: Color(.systemGreen),
            destination: AnyView(FilterFactor())
        ),
    ]
    
    func removeTile(id: String) -> Void {
        layout = layout.filter({ $0.id != id })
    }

    var body: some View {
        return NavigationView {
            VStack {
                ForEach(Array(stride(from: 0, to: self.layout.count, by: 2)), id: \.self) { index in
                    let tile = layout[index]
                    let nextTile = layout[safe: index + 1]

                    HStack {
                        LinkedNavigationTile(
                            tile: tile,
                            isEditing: $isEditing,
                            isDragging: $isDragging,
                            shouldRemoveTile: $shouldRemoveTile,
                            onRemoveTile: removeTile
                        )
                        
                        if nextTile != nil {
                            LinkedNavigationTile(
                                tile: nextTile!,
                                isEditing: $isEditing,
                                isDragging: $isDragging,
                                shouldRemoveTile: $shouldRemoveTile,
                                onRemoveTile: removeTile
                            )
                        }
                    }
                }

                Spacer()
                
                DashboardToolbar(isEditing: $isEditing, isDragging: $isDragging, isDrawerOpen: $isDrawerOpen)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Label("Edit Dashboard", systemImage: "slider.vertical.3")
                    }
                    .foregroundColor(Color(.systemBlue))
                }
                    
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: Settings()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .background(Color(.systemGray6))
        }
    }
}
