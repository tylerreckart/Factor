//
//  AddFilmDataSheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/30/22.
//

import SwiftUI

struct AddFilmDataSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var addData: (Emulsion) -> Void

    @FetchRequest(
      entity: Emulsion.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Emulsion.manufacturer, ascending: true)
      ]
    ) var fetchedResults: FetchedResults<Emulsion>

    var body: some View {
        NavigationView {
            VStack {
                if fetchedResults.isEmpty {
                    VStack {
                        Spacer()
                        Text("Add an emulsion to get started")
                            .foregroundColor(Color(.systemGray))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                } else {
                    List {
                        ForEach(fetchedResults, id: \.self) { result in
                            Button(action: {
                                addData(result)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(result.manufacturer!)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        Text(result.name!)
                                    }
                                    .padding([.top, .bottom], 1)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Add an Emulsion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                    .foregroundColor(Color(.systemGray))
                }
            }
        }
    }
}

