//
//  NoteListContainer.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/21/22.
//

import Foundation
import SwiftUI

struct NoteListContainer: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var results: FetchedResults<Note>

    @State private var searchText = ""
    @State private var localResults: [Note] = []
    @State private var isEditing: Bool = false
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
        if results.count > 0 {
            ScrollView {
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom)

                let notes = filterBySearchText(notes: results)

                ForEach(notes, id: \.self) { group in
                    let month = group.isEmpty ? "" : getMonth(date: group[0].createdAt!)
                    
                    NoteGroup(group: group, month: month, isEditing: $isEditing, selectedNotes: $selectedNotes)
                }
            }
            .background(useDarkMode ? .black : Color(.systemGray6))
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
        } else {
            Text("Add your first note to get started.")
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
