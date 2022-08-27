//
//  AddReciprocityDataSheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct AddReciprocityDataSheet: View {
    @Environment(\.presentationMode) var presentationMode

    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var addData: (Set<ReciprocityData>) -> Void

    @FetchRequest(
      entity: ReciprocityData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \ReciprocityData.timestamp, ascending: false)
      ]
    ) var results: FetchedResults<ReciprocityData>
    
    @State var isEditing: Bool = false
    @State var selectedResults: Set<ReciprocityData> = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(results) { result in
                        ReciprocityDataCard(result: result, isEditing: $isEditing, selectedResults: $selectedResults)
                    }
                }
            }
            .padding([.leading, .trailing])
            .background(Color(.systemGray6))
            .navigationTitle("Add Bellows Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isEditing {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text("Select")
                                .foregroundColor(userAccentColor)
                        }
                    } else {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text("Cancel")
                        }
                        .foregroundColor(Color(.systemGray))
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isEditing {
                        EmptyView()
                    } else if isEditing && selectedResults.count > 0 {
                        Button(action: {
                            if selectedResults.count > 0 {
                                addData(selectedResults)
                            }
                            
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                                .foregroundColor(userAccentColor)
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}
