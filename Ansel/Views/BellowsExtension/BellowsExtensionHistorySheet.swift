//
//  BellowsExtensionHistorySheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct BellowsExtensionHistorySheet: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
      entity: BellowsExtensionData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \BellowsExtensionData.timestamp, ascending: false)
      ]
    ) var results: FetchedResults<BellowsExtensionData>
    
    @State var isEditing: Bool = false
    @State var selectedResults: [BellowsExtensionData] = []
    
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
                        BellowsDataCard(result: result, isEditing: $isEditing, selectedResults: $selectedResults)
                    }
                }
            }
            .padding([.leading, .trailing])
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
                    } else {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text("Done")
                        }
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
