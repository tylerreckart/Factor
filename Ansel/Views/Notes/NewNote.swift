//
//  NewNote.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI
import PhotosUI
import CoreData

enum FocusField: Hashable {
  case noteBody
}

enum DataAlert: Hashable {
    case bellows
    case reciprocity
    case filter
}

struct NewNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        entity: BellowsExtensionData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \BellowsExtensionData.timestamp, ascending: true)
        ]
    ) var bellowsData: FetchedResults<BellowsExtensionData>
    
    @FetchRequest(
        entity: ReciprocityData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ReciprocityData.timestamp, ascending: true)
        ]
    ) var reciprocityData: FetchedResults<ReciprocityData>
    
    @FetchRequest(
        entity: FilterData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FilterData.timestamp, ascending: true)
        ]
    ) var filterData: FetchedResults<FilterData>

    @State private var noteBody: String = ""
    
    @State var showReciprocitySheet: Bool = false
    @State var showFilterSheet: Bool = false
    @State var showBellowsSheet: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: Set<UIImage> = []
    
    @FocusState private var focusedField: FocusField?
    
    @State private var addedBellowsData: Set<BellowsExtensionData> = []
    @State private var addedReciprocityData: Set<ReciprocityData> = []
    @State private var addedFilterData: Set<FilterData> = []
    
    @State private var showAlert: Bool = false
    @State private var alert: DataAlert?
    
    @State private var isSaving: Bool = false
    @State private var saved: Bool = false
    @State private var workItem: DispatchWorkItem?
    
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
    
    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
        for img in images {
            if let data = img.jpegData(compressionQuality: 0.2) {
                dataArray.add(data)
            }
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
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
                
                if selectedPhotosData.count > 0 {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(selectedPhotosData), id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                
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
                    PhotosPicker(
                        selection: $selectedImages,
                        matching: .images
                    ) {
                        Label("Add Images", systemImage: "photo")
                    }
                    .onChange(of: selectedImages) { newItems in
                        Task {
                            selectedImages = []
                            for value in newItems {
                                if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                    selectedPhotosData.insert(image)
                                }
                            }
                        }
                    }
                    
                    Menu {
                        Button(action: {
                            if reciprocityData.count > 0 {
                                showReciprocitySheet.toggle()
                            } else {
                                showAlert.toggle()
                                alert = .reciprocity
                            }
                        }) {
                            Label("Add Reciprocity Data", systemImage: "clock")
                        }
                        
                        Button(action: {
                            if filterData.count > 0 {
                                showFilterSheet.toggle()
                            } else {
                                showAlert.toggle()
                                alert = .filter
                            }
                        }) {
                            Label("Add Filter Data", systemImage: "moon.stars.circle")
                        }
                        
                        Button(action: {
                            if bellowsData.count > 0 {
                                showBellowsSheet.toggle()
                            } else {
                                showAlert.toggle()
                                alert = .bellows
                            }
                        }) {
                            Label("Add Bellows Data", systemImage: "arrow.up.backward.and.arrow.down.forward.circle")
                        }
                    } label: {
                        Label("Add Data", systemImage: "ellipsis.circle")
                    }
                    
                    if noteBody.count > 0 {
                        if isSaving {
                            ProgressView()
                                .padding(.leading, 1)
                        } else {
                            Button(action: {
                                isSaving.toggle()
                                save()
                            }) {
                                Text("Save")
                            }
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
            .alert(isPresented: $showAlert) {
                let str = alert == .filter ? "filter" : alert == .bellows ? "bellows extension" : "reciprocity"
                return Alert(title: Text("No \(str) data found. Perform calculations and try again."))
            }
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
            
            DispatchQueue.main.sync {
                self.presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func save() {
        self.isSaving = true
    
        let newNote = Note(context: managedObjectContext)

        newNote.body = self.noteBody
        newNote.createdAt = Date()

        
        self.workItem = DispatchWorkItem {
            if addedBellowsData.count > 0 {
                newNote.bellowsData = addedBellowsData as NSSet
            }
            
            if addedReciprocityData.count > 0 {
                newNote.reciprocityData = addedReciprocityData as NSSet
            }
            
            if addedFilterData.count > 0 {
                newNote.filterData = addedFilterData as NSSet
            }
            
            if selectedPhotosData.count > 0 {
                newNote.images = coreDataObjectFromImages(images: Array(selectedPhotosData))
            }
            
            saveContext()
            
            //Reset variables on the main thread once finished
            DispatchQueue.main.async {
                self.isSaving = false
            }
        }
        
        if(workItem != nil) {
            DispatchQueue.global().async(execute: workItem!)
        }
    }
}
