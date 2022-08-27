//
//  Note.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct NoteView: View {
    var note: Note
    
    @State var isEditing: Bool = false

    var body: some View {
        VStack {
            Text(note.body!)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if note.bellowsData != nil {
                ForEach(Array(note.bellowsData as! Set<BellowsExtensionData>), id: \.self) { result in
                    BellowsData(result: result)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 8)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.isEditing.toggle()
                }) {
                    Text("Edit")
                }
            }
        }
    }
}
