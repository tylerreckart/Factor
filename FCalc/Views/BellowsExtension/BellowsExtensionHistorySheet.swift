//
//  BellowsExtensionHistorySheet.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct BellowsExtensionHistorySheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    @FetchRequest(
      entity: BellowsExtensionData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \BellowsExtensionData.timestamp, ascending: false)
      ]
    ) var results: FetchedResults<BellowsExtensionData>
    
    @State var isEditing: Bool = false
    @State var selectedResults: Set<BellowsExtensionData> = []
    
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
                            BellowsDataCard(
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
}
