//
//  NoteList.swift
//  Aspen
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
                    withAnimation {
                        showCancelButton = true
                    }
                }).foregroundColor(.primary)
                
                Spacer()
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.background)
            .cornerRadius(8)

            if showCancelButton  {
                Button("Cancel") {
                    withAnimation {
                        UIApplication.shared.endEditing(true)
                        searchText = ""
                        showCancelButton = false
                    }
                }
                .foregroundColor(.accentColor)
            }
        }
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
        if note.body != nil {
            HStack {
                if isEditing {
                    if !selectedNotes.contains(note.id) {
                        Image(systemName: "circle")
                            .foregroundColor(.accentColor)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                }

                let str = note.body!
                
                HStack(alignment: .center) {
                    if !isEditing {
                        NavigationLink(destination: Notepad(note: note)) {
                            VStack(alignment: .leading) {
                                Text(str.count > 72 ? str.prefix(72) + "..." : str)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 1)
                                    .multilineTextAlignment(.leading)
                                
                                Text(formatDate(date: note.createdAt!))
                                    .foregroundColor(Color(.systemGray))
                                    .font(.system(size: 14))
                                
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray5))
                                .font(.system(size: 14, weight: .bold))
                        }
                    } else {
                        Button(action: {
                            if !selectedNotes.contains(note.id) {
                                selectedNotes.append(note.id)
                            } else {
                                selectedNotes = selectedNotes.filter { $0 != note.id }
                            }
                        }) {
                            VStack(alignment: .leading) {
                                let str = note.body!
                                
                                Text(str.count > 72 ? str.prefix(72) + "..." : str)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 1)
                                    .multilineTextAlignment(.leading)
                                
                                Text(formatDate(date: note.createdAt!))
                                    .foregroundColor(Color(.systemGray))
                                    .font(.system(size: 14))
                            }
                            
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.background)
                .cornerRadius(8)
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
    @State private var localResults: [Note] = []
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
                if results.count == 0 {
                    VStack {
                        Spacer()
                        Text("Add your first note to get started")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.systemGray))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .border(width: 0.5, edges: [.top], color: Color(.systemGray4))
                }

                if results.count > 0 {
                    ScrollView {
                        SearchBar(searchText: $searchText)
                            .padding(.horizontal)
                            .padding(.bottom)

                        let notes = filterBySearchText(notes: results)

                        ForEach(notes, id: \.self) { group in
                            let month = group.isEmpty ? "" : getMonth(date: group[0].createdAt!)
                            
                            Section(header:
                                HStack {
                                    Text(month)
                                        .textCase(.none)
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .padding(.leading)
                                    Spacer()
                                }
                            ) {
                                ForEach(group, id: \.self) { r in
                                    NoteListItem(note: r, isEditing: $isEditing, selectedNotes: $selectedNotes)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .background(Color(.systemGray6))
                }
            }
            
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    if results.count > 0 {
                        Text("\(results.count) \(results.count == 1 ? "Note" : "Notes")")
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
                .background(.ultraThickMaterial)
                .border(width: 0.5, edges: [.top], color: Color(.systemGray4))
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
    
    func groupByMonth(notes: [Note]) -> [[Note]] {
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
    
    func filterBySearchText(notes: FetchedResults<Note>) -> [[Note]] {
        var filteredNotes: [Note] = []

        filteredNotes = notes.filter {
            searchText.isEmpty ? true : $0.body!.lowercased().contains(searchText.lowercased())
        }
        
        if filteredNotes.count > 0 {
            return groupByMonth(notes: filteredNotes).reversed()
        }
        
        return []
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
