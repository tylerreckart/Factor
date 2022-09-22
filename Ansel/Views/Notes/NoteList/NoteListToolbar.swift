//
//  NoteListToolbar.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/21/22.
//

import Foundation
import SwiftUI

struct NoteListToolbar: View {
    var results: FetchedResults<Note>

    @Binding var isEditing: Bool
    @Binding var selectedNotes: [ObjectIdentifier]

    var deleteNotes: () -> Void
    
    var body: some View {
        if results.count > 0 {
            if isEditing && selectedNotes.count > 0 {
                Button(action: {
                    if selectedNotes.count > 0 {
                        deleteNotes()
                    }
                    
                    withAnimation {
                        self.isEditing.toggle()
                    }
                }) {
                    Text("Delete")
                }
                .foregroundColor(Color(.systemRed))
            } else if isEditing && selectedNotes.count == 0 {
                Button(action: {
                    withAnimation {
                        self.isEditing.toggle()
                    }
                }) {
                    Text("Cancel")
                }
                .foregroundColor(Color(.systemGray))
            } else {
                Button(action: {
                    withAnimation {
                        self.isEditing.toggle()
                    }
                }) {
                    Text("Select")
                }
                .foregroundColor(.accentColor)
            }
        }
    }
}
