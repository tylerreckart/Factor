//
//  Note.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI
import PhotosUI
import UIKit

struct ReciprocityNoteCard: View {
    var note: Note

    var body: some View {
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
}

struct FilterNoteCard: View {
    var note: Note
    
    var body: some View {
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
}

struct BellowsNoteCard: View {
    var note: Note
    
    var body: some View {
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
}

struct GearItem: View {
    var image: String
    var primary: String
    var secondary: String
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: image)
                .frame(width: 20)
            Text(primary)
            Text(secondary)
        }
        .font(.caption)
        .foregroundColor(.accentColor)
    }
}

struct NoteView: View {
    var note: Note
    
    @State var isEditing: Bool = false
    
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
                Text(note.body!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    if note.camera!.count > 0 {
                        ForEach(Array(note.camera as! Set<Camera>), id: \.self) { camera in
                            GearItem(
                                image: "camera",
                                primary: camera.manufacturer!,
                                secondary: camera.model!
                            )
                        }
                    }

                    if note.lens!.count > 0 {
                        ForEach(Array(note.lens as! Set<Lens>), id: \.self) { lens in
                            GearItem(
                                image: "camera.aperture",
                                primary: lens.manufacturer!,
                                secondary: "\(lens.focalLength)mm f/\(lens.maximumAperture.clean)"
                            )
                        }
                    }

                    if note.emulsion!.count > 0 {
                        ForEach(Array(note.emulsion as! Set<Emulsion>), id: \.self) { emulsion in
                            GearItem(
                                image: "film",
                                primary: emulsion.manufacturer!,
                                secondary: emulsion.name!
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                if noteImages.count > 0 {
                    VStack {
                        ForEach(noteImages, id: \.self) { image in
                            NavigationLink(destination: ImageViewer(image: image)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)
                            }
                            .padding(.bottom)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if note.reciprocityData!.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Reciprocity Data")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                            .padding(.leading, 10)

                        ForEach(Array(note.reciprocityData! as! Set<ReciprocityData>), id: \.self) { data in
                            ReciprocityFactorData(result: data)
                        }
                    }
                    .padding([.leading, .trailing])
                }
                
                if note.filterData!.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Filter Factor Data")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                            .padding(.leading, 10)

                        ForEach(Array(note.filterData! as! Set<FilterData>), id: \.self) { data in
                            FilterFactorData(result: data)
                        }
                    }
                    .padding([.leading, .trailing])
                }
                
                if note.bellowsData!.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Bellows Extension Data")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                            .padding(.leading, 10)
                        
                        ForEach(Array(note.bellowsData! as! Set<BellowsExtensionData>), id: \.self) { data in
                            BellowsData(result: data)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
