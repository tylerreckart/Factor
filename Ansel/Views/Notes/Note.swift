//
//  Note.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI
import PhotosUI

struct NoteView: View {
    var note: Note
    
    @State var isEditing: Bool = false
    
    @State var showReciprocitySheet: Bool = false
    @State var showFilterSheet: Bool = false
    @State var showBellowsSheet: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: [Data] = []
    
    @FocusState private var focusedField: FocusField?
    
    @State private var editBody: String = ""

    var body: some View {
        ScrollView {
            if isEditing {
                TextField("Start typing...", text: $editBody, axis: .vertical)
                    .zIndex(1)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .noteBody)
                    .onAppear {
                        self.focusedField = .noteBody
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 18)
            } else {
                Text(note.body!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
            }
            
            if note.reciprocityData!.count > 0 {
                VStack(alignment: .leading) {
                    Text("Reciprocity Calculations")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                    ForEach(Array(note.reciprocityData as! Set<ReciprocityData>), id: \.self) { result in
                        ReciprocityFactorData(result: result)
                            .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
                    }
                }
                .padding(.bottom, 10)
            }
            
            if note.filterData!.count > 0 {
                VStack(alignment: .leading) {
                    Text("Filter Factor Calculations")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                    ForEach(Array(note.filterData as! Set<FilterData>), id: \.self) { result in
                        FilterFactorData(result: result)
                            .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
                    }
                }
                .padding(.bottom, 10)
            }

            if note.bellowsData!.count > 0 {
                VStack(alignment: .leading) {
                    Text("Bellows Extension Calculations")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                    ForEach(Array(note.bellowsData as! Set<BellowsExtensionData>), id: \.self) { result in
                        BellowsData(result: result)
                            .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Label("Edit Note", systemImage: "pencil")
                    }
    
                    PhotosPicker(
                        selection: $selectedImages,
                        matching: .images
                    ) {
                        Label("Select Images", systemImage: "photo")
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
                        self.showReciprocitySheet.toggle()
                    }) {
                        Label("Select Reciprocity Data", systemImage: "clock")
                    }
                    
                    Button(action: {
                        self.showFilterSheet.toggle()
                    }) {
                        Label("Select Filter Data", systemImage: "moon.stars")
                    }

                    Button(action: {
                        self.showBellowsSheet.toggle()
                    }) {
                        Label("Select Bellows Data", systemImage: "arrow.up.backward.and.arrow.down.forward")
                    }
                }
                label: {
                    Label("Edit", systemImage: "ellipsis.circle")
                }
            }
            
            if isEditing {
                ToolbarItem {
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Text("Done")
                    }
                }
            }
        }
        .sheet(isPresented: $showReciprocitySheet) {
            ReciprocityHistorySheet()
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterHistorySheet()
        }
        .sheet(isPresented: $showBellowsSheet) {
            BellowsExtensionHistorySheet()
        }
        .onAppear {
            editBody = note.body!
        }
    }
}
