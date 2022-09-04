//
//  Notepad.swift
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

struct DeleteButton: View {
    var image: UIImage
    var remove: (UIImage) -> Void
    var title: String
    var message: String

    let screenWidth = UIScreen.main.bounds.width
    
    @State private var presentAlert: Bool = false

    var body: some View {
        Button(action: {
            self.presentAlert.toggle()
        }) {
            Image(systemName: "minus")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.systemGray))
                .frame(width: 25, height: 25)
                .background(.ultraThinMaterial)
                .cornerRadius(.infinity)
                .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)
        }
        .offset(x: (screenWidth / 2) - 20, y: -10)
        .confirmationDialog(title, isPresented: $presentAlert) {
            Button(title, role: .destructive) {
                remove(image)
            }
        } message: {
            Text(message)
          }
    }
}

struct Notepad: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var note: Note?

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
    
    @State private var isEditing: Bool = false
    @State private var animate: Bool = false
    @State private var isSaving: Bool = false

    @State private var workItem: DispatchWorkItem?
    
    @State private var showOverlay: Bool = false
    @State private var overlayImage: UIImage?

    var body: some View {
        VStack {
            ScrollView {
                TextField("Start typing...", text: $noteBody, axis: .vertical)
                    .zIndex(1)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .noteBody)
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
                            if !isEditing {
                                Button(action: {
                                    showOverlay = true
                                    overlayImage = image
                                }) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(8)
                                            .padding(.bottom)
                                }
                            } else {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)
                                    .padding(.bottom)
                                    .overlay(DeleteButton(
                                        image: image,
                                        remove: removeImage,
                                        title: "Remove Image",
                                        message: "Remove this image?\n It can be added again from the photo picker."
                                    ), alignment: .top)
                            }
                        }
                    }
                    .padding([.leading, .trailing])
                }
                
                CalculationData(
                    reciprocityData: $addedReciprocityData,
                    filterData: $addedFilterData,
                    bellowsData: $addedBellowsData
                )
            }
            .padding(.bottom, -10)

            if selectedImages.count == 0 {
                Spacer()
            }
            
            NotepadToolbar(
                showGearSheet: $showGearSheet,
                showDataSheet: $showDataSheet,
                selectedImages: $selectedImages,
                selectedPhotosData: $selectedPhotosData
            )
        }
        .sheet(isPresented: $showGearSheet) {
            GearSheet(save: saveGear)
        }
        .sheet(isPresented: $showDataSheet) {
            DataSheet(save: saveData)
        }
        .overlay(
            showOverlay ? ImageViewer(image: overlayImage!, dismiss: dismissOverlay) : nil
        )
        .onAppear {
            if note != nil {
                noteBody = note!.body!
                focusedField = nil
                
                if note!.images != nil {
                    selectedPhotosData = imagesFromCoreData(object: note!.images)!
                }
                
                if note!.reciprocityData != nil {
                    addedReciprocityData = note!.reciprocityData as! Set<ReciprocityData>
                }
                
                if note!.bellowsData != nil {
                    addedBellowsData = note!.bellowsData as! Set<BellowsExtensionData>
                }
                
                if note!.filterData != nil {
                    addedFilterData = note!.filterData as! Set<FilterData>
                }
                
                if note!.camera != nil {
                    addedCameraData = note!.camera as! Set<Camera>
                }
                
                if note!.lens != nil {
                    addedLensData = note!.lens as! Set<Lens>
                }
                
                if note!.emulsion != nil {
                    addedFilmData = note!.emulsion as! Set<Emulsion>
                }
            } else {
                focusedField = .noteBody
            }
        }
        .onDisappear {
            if noteBody.count > 0 {
                save()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Image(systemName: "square.and.arrow.up")
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text("Edit")
                }
            }
        }
    }
    
    func dismissOverlay() -> Void {
        showOverlay = false
        overlayImage = nil
    }
    
    func removeImage(image: UIImage) -> Void {
        selectedPhotosData.remove(image)
    }
    
    func addBellowsData(data: [BellowsExtensionData]) -> Void {
        data.forEach { result in
            addedBellowsData.insert(result)
        }
    }
    
    func addReciprocityData(data: [ReciprocityData]) -> Void {
        data.forEach { result in
            addedReciprocityData.insert(result)
        }
    }
    
    func addFilterData(data: [FilterData]) -> Void {
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
    
    func saveData(reciprocityData: [ReciprocityData], filterData: [FilterData], bellowsData: [BellowsExtensionData]) -> Void {
        if reciprocityData.count > 0 {
            addReciprocityData(data: reciprocityData)
        }
        
        if filterData.count > 0 {
            addFilterData(data: filterData)
        }
        
        if bellowsData.count > 0 {
            addBellowsData(data: bellowsData)
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
    
    func imagesFromCoreData(object: Data?) -> Set<UIImage>? {
        var retVal = Set<UIImage>()

        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    retVal.insert(image)
                }
            }
        }
        
        return retVal
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
    
        let newNote = note ?? Note(context: managedObjectContext)

        newNote.body = noteBody
        
        if note == nil {
            newNote.createdAt = Date()
        }

        
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
                isSaving = false
            }
        }
        
        if workItem != nil {
            DispatchQueue.global().async(execute: workItem!)
        }
    }
}
