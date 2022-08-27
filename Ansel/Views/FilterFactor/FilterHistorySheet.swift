//
//  FilterHistorySheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/26/22.
//

import SwiftUI

struct FilterHistorySheet: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    @FetchRequest(
      entity: FilterData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \FilterData.timestamp, ascending: true)
      ]
    ) var results: FetchedResults<FilterData>
    
    @State var isEditing: Bool = false
    @State var selectedResults: Set<FilterData> = []
    
    func deleteSelectedResults() -> Void {
        self.selectedResults.forEach { item in
            managedObjectContext.delete(item)

            do{
                try managedObjectContext.save()
            } catch{
                print(error)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(results) { result in
                        FilterDataCard(
                            result: result,
                            isEditing: $isEditing,
                            selectedResults: $selectedResults
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 8)
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isEditing {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Image(systemName: "square.and.pencil")
                            Text("Edit")
                        }
                        .foregroundColor(userAccentColor)
                    } else {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text("Done")
                        }
                        .foregroundColor(userAccentColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isEditing {
                        EmptyView()
                    } else if isEditing && selectedResults.count > 0 {
                        Button(action: {
                            deleteSelectedResults()
                        }) {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                        .foregroundColor(Color(.systemRed))
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}
