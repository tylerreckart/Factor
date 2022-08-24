//
//  DashboardToolbar.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct DashboardToolbar: View {
    @Binding var isEditing: Bool
    @Binding var isDragging: Bool
    @Binding var isDrawerOpen: Bool
    
    @State var ypos: CGFloat = 0
    
    var body: some View {
        if isEditing {
            HStack {
                Button(action: {
                    isDrawerOpen = true
                }) {
                    Label("Add Tiles", systemImage: "plus.app")
                }
                
                Spacer()
                
                Button(action: {
                    isEditing = false
                }) {
                    Label("Done", systemImage: "")
                }
            }
            .offset(y: ypos)
            .onChange(of: isDragging) { newState in
                if isDragging {
                    ypos = 1000
                } else {
                    ypos = 0
                }
            }
            .animation(.easeInOut(duration: 0.5), value: ypos)
        }
    }
}
