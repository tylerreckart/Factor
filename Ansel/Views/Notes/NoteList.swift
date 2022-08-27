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
    
    @State private var isEditing: Bool = false
    
    @FetchRequest(
      entity: Note.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)
      ]
    ) var results: FetchedResults<Note>
    
    @State private var selectedNotes: [ObjectIdentifier] = []
    
    func deleteNotes() {
        selectedNotes.forEach { id in
            let note = results.filter({ $0.id == id }).first
            
            self.managedObjectContext.delete(note!)
            self.managedObjectContext.refreshAllObjects()

            saveContext()
        }
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }

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
                    .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.horizontal)
    
            List {
                ForEach(results.filter { searchText.isEmpty ? true : $0.body!.contains(searchText) }, id: \.self) { r in
                    if !isEditing {
                        let str = r.body!

                        NavigationLink(destination: NoteView(note: r)) {
                            VStack(alignment: .leading) {
                                Text(formatDate(date: r.createdAt!))
                                    .foregroundColor(.accentColor)
                                    .padding(.bottom, 1)
                                    .font(.system(size: 14))
                                
                                Text(str.count > 80 ? str.prefix(80) + "..." : str)
                                    .foregroundColor(Color(.gray))
                            }
                        }
                    } else {
                        Button(action: {
                            if !selectedNotes.contains(r.id) {
                                selectedNotes.append(r.id)
                            } else {
                                selectedNotes = selectedNotes.filter { $0 != r.id }
                            }
                        }) {
                            HStack {
                                if !selectedNotes.contains(r.id) {
                                    Image(systemName: "circle")
                                        .foregroundColor(.accentColor)
                                } else {
                                     Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                }
                                
                                VStack(alignment: .leading) {
                                    let str = r.body!
                            
                                    Text(formatDate(date: r.createdAt!))
                                        .foregroundColor(.accentColor)
                                        .padding(.bottom, 1)
                                    
                                    Text(str.count > 80 ? str.prefix(80) + "..." : str)
                                        .foregroundColor(Color(.gray))
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if results.count > 0 {
                        if isEditing && selectedNotes.count > 0 {
                            Button(action: {
                                if selectedNotes.count > 0 {
                                    deleteNotes()
                                }
                                
                                self.isEditing.toggle()
                            }) {
                                Text("Delete")
                            }
                            .foregroundColor(Color(.systemRed))
                        } else if isEditing && selectedNotes.count == 0 {
                            Button(action: {
                                self.isEditing.toggle()
                            }) {
                                Text("Cancel")
                            }
                            .foregroundColor(Color(.systemGray))
                        } else {
                            Button(action: {
                                self.isEditing.toggle()
                            }) {
                                Text("Edit")
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewNote()) {
                        Label("New Note", systemImage: "square.and.pencil")
                    }
                    .foregroundColor(.accentColor)
                }
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
