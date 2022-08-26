//
//  DashboardToolbar.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct DashboardToolbar: View {
    @Binding var isEditing: Bool
    @Binding var showTileSheet: Bool
    
    var body: some View {
        if isEditing {
            HStack {
                Button(action: {
                    showTileSheet.toggle()
                }) {
                    Label("Add Tiles", systemImage: "plus.app")
                }
                .foregroundColor(.accentColor)
                
                Spacer()
                
                Button(action: {
                    isEditing = false
                }) {
                    Text("Done")
                }
                .foregroundColor(.accentColor)
            }
        }
    }
}
