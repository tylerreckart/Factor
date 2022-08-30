//
//  Note.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI
import PhotosUI

struct ImageViewer: View {
    var image: UIImage

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

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
    
    @State private var noteImages: [UIImage] = []
    
    func imagesFromCoreData(object: Data?) -> [UIImage]? {
        var retVal = [UIImage]()

        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    retVal.append(image)
                }
            }
        }
        
        return retVal
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                
                if noteImages.count > 0 {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(noteImages, id: \.self) { image in
                                NavigationLink(destination: ImageViewer(image: image)) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                
                VStack(alignment: .leading) {
                    if note.camera != nil {
                        ZStack {
                            HStack(spacing: 2) {
                                Image(systemName: "camera")
                                Text(note.camera!.manufacturer!)
                                Text(note.camera!.model!)
                            }
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        }
                        .padding([.top, .bottom], 8)
                        .padding([.leading, .trailing], 12)
                        .background(Color.accentColor.opacity(0.05))
                        .cornerRadius(.infinity)
                    }
                    
                    if note.emulsion != nil {
                        ZStack {
                            HStack(spacing: 2) {
                                Image(systemName: "film")
                                Text(note.emulsion!.manufacturer!)
                                Text(note.emulsion!.name!)
                            }
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        }
                        .padding([.top, .bottom], 8)
                        .padding([.leading, .trailing], 12)
                        .background(Color.accentColor.opacity(0.05))
                        .cornerRadius(.infinity)
                    }
                    
                    if note.lens != nil {
                        ZStack {
                            HStack(spacing: 2) {
                                Image(systemName: "camera.aperture")
                                Text(note.lens!.manufacturer!)
                                Text("\(note.lens!.focalLength)mm f/\(note.lens!.maximumAperture.clean)")
                            }
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        }
                        .padding([.top, .bottom], 8)
                        .padding([.leading, .trailing], 12)
                        .background(Color.accentColor.opacity(0.05))
                        .cornerRadius(.infinity)
                    }
                }
                .padding(.bottom, 10)
                
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
                
                let dataImages = note.images ?? Data()
                if dataImages.count > 0 {
                    noteImages = imagesFromCoreData(object: dataImages)!
                }
            }
        }
    }
}
