//
//  TileSheet.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct TileSheet: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var activeTiles: [DashboardTile] = []
    @State private var inactiveTiles: [DashboardTile] = []

    @State private var isEditing: Bool = false
    
    func emptyFunc(id: String) -> Void {}
    
    var addTile: (DashboardTile) -> Void

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
                            SimpleTile(tile: tile, isDisabled: false)
                        }
                    }
                    .padding(.bottom, 10)
                }
                
                if activeTiles.count > 0 {
                    Text("Active Tiles")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        
                    ForEach(activeTiles) { tile in
                        SimpleTile(tile: tile, isDisabled: true)
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
