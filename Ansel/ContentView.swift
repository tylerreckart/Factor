//
//  ContentView.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isDrawerOpen: Bool = false
    @State private var isDragging: Bool = false
    @State private var shouldRemoveTile: Bool = false
    
    var body: some View {
        ZStack {
            Dashboard(
                isDrawerOpen: $isDrawerOpen,
                isDragging: $isDragging,
                shouldRemoveTile: $shouldRemoveTile
            )
            
            TileTrashBin(
                isDragging: $isDragging,
                isDrawerOpen: $isDrawerOpen,
                shouldRemoveTile: $shouldRemoveTile
            )
            
            if isDrawerOpen {
                Drawer(isOpen: $isDrawerOpen).edgesIgnoringSafeArea(.vertical)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
