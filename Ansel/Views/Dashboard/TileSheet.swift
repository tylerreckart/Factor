//
//  TileSheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct TileSheet: View {
    @Environment(\.presentationMode) var presentationMode

    @AppStorage("userDashboardLayout") var dashboard: [String] = dashboard_tiles.map { $0.id }

    let availableTiles = dashboard_tiles.map { $0.id }

    @State private var activeTiles: [DashboardTile] = []
    @State private var inactiveTiles: [DashboardTile] = []

    @State private var isEditing: Bool = false
    
    func emptyFunc(id: String) -> Void {}
    
    var addTile: (DashboardTile) -> Void
    
    func getActiveTiles() -> Void {
        var tiles: [DashboardTile] = []
    
        dashboard.unique().forEach { id in
            tiles.append(dashboard_tiles.filter({ $0.id == id }).first!)
        }
        
        activeTiles = tiles
    }
    
    func getInactiveTiles() -> Void {
        var tiles: [DashboardTile] = []
        
        dashboard_tiles.forEach { tile in
            let id = tile.id
            
            if !dashboard.contains(id) {
                tiles.append(tile)
            }
        }

        inactiveTiles = tiles
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if inactiveTiles.count > 0 {
                    Text("Inactive Tiles")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))

                    ForEach(inactiveTiles) { tile in
                        Button(action: {
                            let tileToInsert = inactiveTiles.filter({ $0.id == tile.id }).first

                            addTile(tileToInsert!)

                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            SimpleTile(tile: tile, isDisabled: false, isEditing: $isEditing, removeTile: emptyFunc)
                        }
                    }
                    .padding(.bottom, 10)
                }
                
                if activeTiles.count > 0 {
                    Text("Active Tiles")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        
                    ForEach(activeTiles) { tile in
                        SimpleTile(tile: tile, isDisabled: true, isEditing: $isEditing, removeTile: emptyFunc)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            getActiveTiles()
            getInactiveTiles()
        }
    }
}
