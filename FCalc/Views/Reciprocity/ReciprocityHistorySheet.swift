//
//  ReciprocityHistorySheet.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI


struct ReciprocityHistorySheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    @FetchRequest(
      entity: ReciprocityData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \ReciprocityData.timestamp, ascending: false)
      ]
    ) var results: FetchedResults<ReciprocityData>
    
    @State var isEditing: Bool = false
    @State var selectedResults: Set<ReciprocityData> = []
    
    func deleteSelectedResults() -> Void {
        self.selectedResults.forEach { item in
            managedObjectContext.delete(item)

            do{
                try managedObjectContext.save()
            } catch{
                print(error)
            }
        }
        
        if results.count == 0 {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        NavigationView {
            if results.count > 0 {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(results) { result in
                            ReciprocityDataCard(
                                result: result,
                                isEditing: $isEditing,
                                selectedResults: $selectedResults
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 10, y: 8)
                        }
                    }
                    .padding()
                }
                .accentColor(userAccentColor)
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
}
