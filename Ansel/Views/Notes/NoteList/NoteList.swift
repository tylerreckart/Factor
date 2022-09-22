//
//  NoteList.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct NoteListBottomToolbar: View {
    var count: Int

    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                if count > 0 {
                    Text("\(count) \(count == 1 ? "Note" : "Notes")")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .padding(.top, 5)
                        .padding(.leading, 20)
                    Spacer()
                }

                NavigationLink(destination: Notepad()) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20))
                }
            }
            .padding()
            .background(.thickMaterial)
            .border(width: 0.5, edges: [.top], color: Color(.systemGray4))
        }
    }
}

struct NoteList: View {
    @FetchRequest(
      entity: Note.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)
      ]
    ) var results: FetchedResults<Note>

    var body: some View {
        ZStack {
            NoteListContainer(results: results)
            NoteListBottomToolbar(count: results.count)
        }
    }
}
