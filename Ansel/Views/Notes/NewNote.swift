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
    @State private var showGearSheet: Bool = false
    @State private var showDataSheet: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: Set<UIImage> = []
    
    @State private var addedBellowsData: Set<BellowsExtensionData> = []
    @State private var addedReciprocityData: Set<ReciprocityData> = []
    @State private var addedFilterData: Set<FilterData> = []

    @State private var addedCameraData: [Camera] = []
    @State private var addedLensData: [Lens] = []
    @State private var addedFilmData: [Emulsion] = []

    var body: some View {
        VStack {
            ScrollView {
                Notepad()
                
                VStack(alignment: .leading, spacing: 10) {
                    if addedCameraData.count > 0 {
                        ForEach(addedCameraData, id: \.self) { camera in
                            HStack(spacing: 2) {
                                Image(systemName: "camera")
                                    .frame(width: 20)
                                Text(camera.manufacturer!)
                                Text(camera.model!)
                                
                                Spacer()
                            }
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        }
                    }
                    
                    if addedLensData.count > 0 {
                        ForEach(addedLensData, id: \.self) { lens in
                            HStack(spacing: 2) {
                                Image(systemName: "camera.aperture")
                                    .frame(width: 20)
                                Text(lens.manufacturer!)
                                Text("\(lens.focalLength)mm f/\(lens.maximumAperture.clean)")
                                
                                Spacer()
                            }
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        }
                    }
                    
                    if addedFilmData.count > 0 {
                        ForEach(addedFilmData, id: \.self) { emulsion in
                            HStack(spacing: 2) {
                                Image(systemName: "film")
                                    .frame(width: 20)
                                Text(emulsion.manufacturer!)
                                Text(emulsion.name!)
                                
                                Spacer()
                            }
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
                
                if selectedPhotosData.count > 0 {
                    VStack {
                        ForEach(Array(selectedPhotosData), id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                                .padding(.bottom)
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
            .padding(.bottom, -10)

            if selectedImages.count == 0 {
                Spacer()
            }
            
            HStack {
                PhotosPicker(
                    selection: $selectedImages,
                    matching: .images
                ) {
                    Image(systemName: "photo")
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
                Spacer()
                Image(systemName: "camera")
                Spacer()
                Button(action: {
                    showGearSheet.toggle()
                }) {
                    Image(systemName: "backpack")
                }
                Spacer()
                Button(action: {
                    showDataSheet.toggle()
                }) {
                    Image(systemName: "ellipsis.circle")
                }.popover(
                    isPresented: $showDataSheet,
                    arrowEdge: .bottom
                ) { Text("Popover") }
            }
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 15)
            .padding([.leading, .trailing], 30)
            .background(Color(.systemGray6))
        }
        .sheet(isPresented: $showGearSheet) {
            GearSheet(save: saveGear)
        }
    }
    
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
    
    func addCameraData(cameras: [Camera]) -> Void {
        cameras.forEach { camera in
            addedCameraData.append(camera)
        }
    }
    
    func addLensData(lenses: [Lens]) -> Void {
        lenses.forEach { lens in
            addedLensData.append(lens)
        }
    }
    
    func addFilmData(emulsions: [Emulsion]) -> Void {
        emulsions.forEach { emulsion in
            addedFilmData.append(emulsion)
        }
    }
    
    func saveGear(cameras: [Camera], lenses: [Lens], emulsions: [Emulsion]) -> Void {
        if cameras.count > 0 {
            addCameraData(cameras: cameras)
        }
        
        if lenses.count > 0 {
            addLensData(lenses: lenses)
        }
        
        if emulsions.count > 0 {
            addFilmData(emulsions: emulsions)
        }
    }
}

struct Notepad: View {
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
    
    @State private var showReciprocitySheet: Bool = false
    @State private var showFilterSheet: Bool = false
    @State private var showBellowsSheet: Bool = false
    @State private var showCameraSheet: Bool = false
    @State private var showLensSheet: Bool = false
    @State private var showFilmSheet: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: Set<UIImage> = []
    
    @FocusState private var focusedField: FocusField?
    
    @State private var addedBellowsData: Set<BellowsExtensionData> = []
    @State private var addedReciprocityData: Set<ReciprocityData> = []
    @State private var addedFilterData: Set<FilterData> = []
    @State private var addedCameraData: Camera?
    @State private var addedLensData: Lens?
    @State private var addedFilmData: Emulsion?
    
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
            VStack(alignment: .leading) {
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
            .onDisappear {
                if noteBody.count > 0 {
                    save()
                }
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
            
            if addedCameraData != nil {
                newNote.camera = addedCameraData
            }
            
            if addedLensData != nil {
                newNote.lens = addedLensData
            }
            
            if addedFilmData != nil {
                newNote.emulsion = addedFilmData
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
