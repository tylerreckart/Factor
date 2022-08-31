//
//  NoteList.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    @State private var showCancelButton: Bool = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                    showCancelButton = true
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
                    searchText = ""
                    showCancelButton = false
                }
                .foregroundColor(Color(.systemGray))
            }
        }
        .padding(.horizontal)
    }
}

struct NoteListItem: View {
    var note: Note

    @Binding var isEditing: Bool
    @Binding var selectedNotes: [ObjectIdentifier]
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/y"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        if !isEditing {
            let str = note.body!
            
            NavigationLink(destination: NoteView(note: note)) {
                VStack(alignment: .leading) {
                    Text(str.count > 80 ? str.prefix(80) + "..." : str)
                        .foregroundColor(.primary)
                        .padding(.bottom, 1)
                    
                    Text(formatDate(date: note.createdAt!))
                        .foregroundColor(Color(.systemGray))
                        .font(.system(size: 14))
                    
                }
            }
        } else {
            Button(action: {
                if !selectedNotes.contains(note.id) {
                    selectedNotes.append(note.id)
                } else {
                    selectedNotes = selectedNotes.filter { $0 != note.id }
                }
            }) {
                HStack {
                    if !selectedNotes.contains(note.id) {
                        Image(systemName: "circle")
                            .foregroundColor(.accentColor)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading) {
                        let str = note.body!
                        
                        Text(str.count > 80 ? str.prefix(80) + "..." : str)
                            .foregroundColor(.primary)
                            .padding(.bottom, 1)
                        
                        Text(formatDate(date: note.createdAt!))
                            .foregroundColor(Color(.systemGray))
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
}

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
}

struct NoteList: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var searchText = ""
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
            
            if note != nil {
                self.managedObjectContext.delete(note!)
            }
        }
        
        self.managedObjectContext.refreshAllObjects()
        saveContext()
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }

    var body: some View {
        ZStack {
            VStack {
                SearchBar(searchText: $searchText)
                
                List {
                    ForEach(groupByMonth(notes: results), id: \.self) { group in
                        let month = group.isEmpty ? "" : getMonth(date: group[0].createdAt!)
                        
                        Section(header:
                                    Text(month)
                            .textCase(.none)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        ) {
                            ForEach(filterBySearchText(notes: group), id: \.self) { r in
                                NoteListItem(note: r, isEditing: $isEditing, selectedNotes: $selectedNotes)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .padding(.vertical, 4)
                }
                .border(width: 1, edges: [.top], color: Color(.systemGray5))
            }
            
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(results.count) Notes")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .padding(.top, 5)
                    Spacer()

                    NavigationLink(destination: NewNote()) {
                        Image(systemName: "square.and.pencil")
                    }
                }
                .padding()
                .background(.thinMaterial)
                .border(width: 1, edges: [.top], color: Color(.systemGray5))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NoteListToolbar(
                    results: results,
                    isEditing: $isEditing,
                    selectedNotes: $selectedNotes,
                    deleteNotes: deleteNotes
                )
            }
        }
    }
    
    func getMonth(date: Date) -> String {
        let currentMonth = Calendar.current.component(.month, from: Date())

        if date.month == currentMonth {
            return "This Month"
        } else if date.month == currentMonth - 1 {
            return "Last Month"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: date)
        }
    }
    
    func groupByMonth(notes: FetchedResults<Note>) -> [[Note]] {
        var result: [[Note]] = []
        
        (1...12).forEach { month in
            var group: [Note] = []
            notes.forEach { note in
                if note.createdAt!.month == month {
                    group.append(note)
                }
            }

            if !group.isEmpty {
                result.append(group)
            }
        }
        
        return result
    }
    
    func filterBySearchText(notes: [Note]) -> [Note] {
        return results.filter { searchText.isEmpty ? true : $0.body!.contains(searchText) }
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
