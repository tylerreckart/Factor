//
//  AddBellowsDataSheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/26/22.
//

import SwiftUI

struct AddBellowsDataSheet: View {
    @Environment(\.presentationMode) var presentationMode

    var addData: (Set<BellowsExtensionData>) -> Void

    @FetchRequest(
      entity: BellowsExtensionData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \BellowsExtensionData.timestamp, ascending: false)
      ]
    ) var results: FetchedResults<BellowsExtensionData>
    
    @State var isEditing: Bool = false
    @State var selectedResults: Set<BellowsExtensionData> = []
    
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
            .navigationTitle("Add Bellows Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isEditing {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text("Select")
                        }
                    } else {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text("Cancel")
                        }
                        .foregroundColor(Color(.systemRed))
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
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}
