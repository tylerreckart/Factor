//
//  NoteList.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct NoteList: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var showNewNoteSheet: Bool = false
    
    @FetchRequest(
      entity: Note.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)
      ]
    ) var results: FetchedResults<Note>

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        print("onCommit")
                    }).foregroundColor(.primary)

                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: showCancelButton ? 6 : 10, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)

                if showCancelButton  {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
    
            List {
                ForEach(results, id: \.self) { r in
                    NavigationLink(destination: NoteView(note: r)) {
                        VStack {
                            HStack {
                                Text(r.body!)
                                    .font(.system(.headline).bold())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(formatDate(date: r.createdAt!))
                                    .foregroundColor(Color(.systemBlue))
                            }
                            .padding(.bottom, 1)
                            
                            HStack {
                                Text(r.body!)
                                    .foregroundColor(Color(.gray))
                                Spacer()
                            }
                            
                        }
                    }
                }
                .onDelete { indexSet in
                    do{
                        try indexSet.forEach { i in
                            self.managedObjectContext.delete(results[i])
                            self.managedObjectContext.refreshAllObjects()
                            try self.managedObjectContext.save()
                        }
                    }catch{
                        print(error)
                    }
                }
                .padding(.vertical, 4)
            }
            .resignKeyboardOnDragGesture()
            .listStyle(.plain)
            .toolbar {
                NavigationLink(destination: NewNote()) {
                    Label("New Note", systemImage: "square.and.pencil")
                }
                .foregroundColor(.accentColor)
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/y"
        return dateFormatter.string(from: date)
    }
    
    private func deleteNote(note: Note){
            managedObjectContext.delete(note)
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
    }
}
