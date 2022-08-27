//
//  NewNote.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI
import PhotosUI

enum FocusField: Hashable {
  case noteBody
}

struct NewNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var noteBody: String = ""
    
    @State var showReciprocitySheet: Bool = false
    @State var showFilterSheet: Bool = false
    @State var showBellowsSheet: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: [Data] = []
    
    @FocusState private var focusedField: FocusField?
    
    @State private var addedBellowsData: Set<BellowsExtensionData> = []
    @State private var addedReciprocityData: Set<ReciprocityData> = []
    @State private var addedFilterData: Set<FilterData> = []
    
    func addBellowsData(data: Set<BellowsExtensionData>) -> Void {
        data.forEach { result in
            addedBellowsData.insert(result)
        }
    }
    
    func addReciprocityData(data: Set<ReciprocityData>) -> Void {
        data.forEach { result in
            addedReciprocityData.insert(result)
        }
    }
    
    func addFilterData(data: Set<FilterData>) -> Void {
        data.forEach { result in
            addedFilterData.insert(result)
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                TextField("Start typing...", text: $noteBody, axis: .vertical)
                    .zIndex(1)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .noteBody)
                    .onAppear {
                        self.focusedField = .noteBody
                    }
                    .padding(.bottom, 10)
                
                if addedReciprocityData.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Reciprocity Calculations")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                        ForEach(Array(addedReciprocityData), id: \.self) { result in
                            ReciprocityFactorData(result: result)
                                .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
                        }
                    }
                    .padding(.bottom)
                }
                
                if addedFilterData.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Filter Factor Calculations")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                        ForEach(Array(addedFilterData), id: \.self) { result in
                            FilterFactorData(result: result)
                                .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
                        }
                    }
                    .padding(.bottom, 10)
                }
    
                if addedBellowsData.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Bellows Extension Calculations")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                        ForEach(Array(addedBellowsData), id: \.self) { result in
                            BellowsData(result: result)
                                .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
                        }
                    }
                    .padding(.bottom)
                }
                
                Spacer()
            }
            .toolbar {
                HStack {
                    Menu {
                        PhotosPicker(
                            selection: $selectedImages,
                            matching: .images
                        ) {
                            Label("Add Images", systemImage: "photo")
                        }
                        .onChange(of: selectedImages) { newItems in
                            for newItem in newItems {
                                Task {
                                    if let data = try? await newItem.loadTransferable(type:Data.self) {
                                        selectedPhotosData.append(data)
                                    }
                                }
                            }
                        }

                        Button(action: {
                            showReciprocitySheet.toggle()
                        }) {
                            Label("Add Reciprocity Data", systemImage: "clock")
                        }
                        
                        Button(action: {
                            showFilterSheet.toggle()
                        }) {
                            Label("Add Filter Data", systemImage: "moon.stars.circle")
                        }

                        Button(action: {
                            showBellowsSheet.toggle()
                        }) {
                            Label("Add Bellows Data", systemImage: "arrow.up.backward.and.arrow.down.forward.circle")
                        }
                    }
                    label: {
                        Label("Add Data", systemImage: "ellipsis.circle")
                    }

                    if noteBody.count > 0 {
                        Button(action: {
                            save()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                        }
                    } else {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                        }
                        .foregroundColor(Color(.systemGray))
                    }
                    
                }
            }
            .padding([.top, .leading, .trailing])
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showReciprocitySheet) {
                AddReciprocityDataSheet(addData: addReciprocityData)
            }
            .sheet(isPresented: $showFilterSheet) {
                AddFilterDataSheet(addData: addFilterData)
            }
            .sheet(isPresented: $showBellowsSheet) {
                AddBellowsDataSheet(addData: addBellowsData)
            }
        }
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func save() {
        let newNote = Note(context: managedObjectContext)

        newNote.body = self.noteBody
        newNote.createdAt = Date()

        if addedBellowsData.count > 0 {
            newNote.bellowsData = addedBellowsData as NSSet
        }
        
        if addedReciprocityData.count > 0 {
            newNote.reciprocityData = addedReciprocityData as NSSet
        }
        
        if addedFilterData.count > 0 {
            newNote.filterData = addedFilterData as NSSet
        }

        saveContext()
    }
}
