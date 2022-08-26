//
//  TileSheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct TileSheet: View {
    @State private var layout: [DashboardTile] = dashboard_tiles
    @State private var isEditing: Bool = false
    
    @Binding var activeTileIds: [String?]
    
    func emptyFunc(id: String) -> Void {}
    
    var addTile: (DashboardTile) -> Void
    
    @Binding var showTileSheet: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if activeTileIds.count > layout.count {
                    Text("Available Tiles")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                }
                
                ForEach(layout) { tile in
                    if !activeTileIds.contains(tile.id) {
                        Button(action: {
                            let tileToInsert = layout.filter{ $0.id == tile.id }.first
                            
                            addTile(tileToInsert!)
                            
                            showTileSheet = false
                        }) {
                            SimpleTile(tile: tile, isDisabled: false, isEditing: $isEditing, removeTile: emptyFunc)
                        }
                    }
                }
                .padding(.bottom, 10)
                
                Text("Active Tiles")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                
                ForEach(layout) { tile in
                    if activeTileIds.contains(tile.id) {
                        SimpleTile(tile: tile, isDisabled: true, isEditing: $isEditing, removeTile: emptyFunc)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}
