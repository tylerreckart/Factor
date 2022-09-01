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

struct CameraData: View {
    @Binding var addedCameraData: Set<Camera>
    @Binding var addedLensData: Set<Lens>
    @Binding var addedFilmData: Set<Emulsion>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if addedCameraData.count > 0 {
                ForEach(Array(addedCameraData), id: \.self) { camera in
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
                ForEach(Array(addedLensData), id: \.self) { lens in
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
                ForEach(Array(addedFilmData), id: \.self) { emulsion in
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
    }
}

struct NewNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var showGearSheet: Bool = false
    @State private var showDataSheet: Bool = false
    
    @State private var noteBody: String = ""
    
    @FocusState private var focusedField: FocusField?
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: Set<UIImage> = []
    
    @State private var addedBellowsData: Set<BellowsExtensionData> = []
    @State private var addedReciprocityData: Set<ReciprocityData> = []
    @State private var addedFilterData: Set<FilterData> = []

    @State private var addedCameraData: Set<Camera> = []
    @State private var addedLensData: Set<Lens> = []
    @State private var addedFilmData: Set<Emulsion> = []
    
    @State private var isSaving: Bool = false
    @State private var workItem: DispatchWorkItem?

    var body: some View {
        VStack {
            ScrollView {
                TextField("Start typing...", text: $noteBody, axis: .vertical)
                    .zIndex(1)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .noteBody)
                    .onAppear {
                        self.focusedField = .noteBody
                    }
                    .padding([.leading, .trailing, .top])
                    .padding(.bottom, 10)
                
                CameraData(
                    addedCameraData: $addedCameraData,
                    addedLensData: $addedLensData,
                    addedFilmData: $addedFilmData
                )
                
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
                }
            }
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 15)
            .padding([.leading, .trailing], 30)
            .background(Color(.systemGray6))
        }
        .sheet(isPresented: $showGearSheet) {
            GearSheet(save: saveGear)
        }
        .onDisappear {
            if noteBody.count > 0 {
                save()
            }
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
            addedCameraData.insert(camera)
        }
    }
    
    func addLensData(lenses: [Lens]) -> Void {
        lenses.forEach { lens in
            addedLensData.insert(lens)
        }
    }
    
    func addFilmData(emulsions: [Emulsion]) -> Void {
        emulsions.forEach { emulsion in
            addedFilmData.insert(emulsion)
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
    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
        for img in images {
            if let data = img.jpegData(compressionQuality: 0.2) {
                dataArray.add(data)
            }
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
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
        isSaving = true
    
        let newNote = Note(context: managedObjectContext)

        newNote.body = noteBody
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
            
            if addedCameraData.count > 0 {
                newNote.camera = addedCameraData as NSSet
            }
            
            if addedLensData.count > 0 {
                newNote.lens = addedLensData  as NSSet
            }
            
            if addedFilmData.count > 0 {
                newNote.emulsion = addedFilmData  as NSSet
            }
            
            saveContext()
            
            //Reset variables on the main thread once finished
            DispatchQueue.main.async {
                self.isSaving = false
            }
        }
        
        if workItem != nil {
            DispatchQueue.global().async(execute: workItem!)
        }
    }
}
