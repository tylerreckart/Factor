//
//  CameraData.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI

struct CameraDataListing: View {
    var camera: Camera
    var removeCamera: (Camera) -> Void

    @Binding var isEditing: Bool
    
    @State private var presentCameraAlert: Bool = false
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "camera")
                .frame(width: 20)
            Text(camera.manufacturer!)
            Text(camera.model!)
            
//            if isEditing {
//                Button(action: {
//                    presentCameraAlert.toggle()
//                }) {
//                    Image(systemName: "minus.circle.fill")
//                        .frame(width: 24)
//                        .foregroundColor(Color(.systemRed))
//                        .confirmationDialog("Remove Camera?", isPresented: $presentCameraAlert) {
//                            Button("Remove", role: .destructive) {
//                                removeCamera(camera)
//                            }
//                        } message: {
//                            Text("Remove this camera? It may be added again later.")
//                        }
//                }
//            }
            
            Spacer()
        }
        .font(.caption)
        .foregroundColor(.accentColor)
    }
}

struct CameraData: View {
    @Binding var addedCameraData: Set<Camera>
    @Binding var addedLensData: Set<Lens>
    @Binding var addedFilmData: Set<Emulsion>
    
    @Binding var isEditing: Bool
    
    var removeEmulsion: (Emulsion) -> Void
    var removeLens: (Lens) -> Void
    var removeCamera: (Camera) -> Void
    
    @State private var presentEmulsionAlert: Bool = false
    @State private var presentLensAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if addedCameraData.count > 0 {
                ForEach(Array(addedCameraData), id: \.self) { camera in
                    CameraDataListing(camera: camera, removeCamera: removeCamera, isEditing: $isEditing)
                }
            }
            
            if addedLensData.count > 0 {
                ForEach(Array(addedLensData), id: \.self) { lens in
                    HStack(spacing: 2) {
                        Image(systemName: "camera.aperture")
                            .frame(width: 20)
                        Text(lens.manufacturer!)
                        Text("\(lens.focalLength)mm f/\(lens.maximumAperture.clean)")
                        
//                        if isEditing {
//                            Button(action: {
//                                presentLensAlert.toggle()
//                            }) {
//                                Image(systemName: "minus.circle.fill")
//                                    .frame(width: 24)
//                                    .foregroundColor(Color(.systemRed))
//                                    .confirmationDialog("Remove Lens?", isPresented: $presentLensAlert) {
//                                        Button("Remove", role: .destructive) {
//                                            removeLens(lens)
//                                        }
//                                    } message: {
//                                        Text("Remove this lens? It may be added again later.")
//                                    }
//                            }
//                        }

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
                            .font(.caption)
                            .frame(width: 20)
                        Text(emulsion.manufacturer!)
                            .font(.caption)
                        Text(emulsion.name!)
                            .font(.caption)
                        
//                        if isEditing {
//                            Button(action: {
//                                presentEmulsionAlert.toggle()
//                            }) {
//                                Image(systemName: "minus.circle.fill")
//                                    .frame(width: 24)
//                                    .foregroundColor(Color(.systemRed))
//                                    .confirmationDialog("Remove Emulsion?", isPresented: $presentEmulsionAlert) {
//                                        Button("Remove", role: .destructive) {
//                                            removeEmulsion(emulsion)
//                                        }
//                                    } message: {
//                                        Text("Remove this emulsion? It may be added again later.")
//                                    }
//                            }
//                        }
                        
                        Spacer()
                    }
                    .foregroundColor(.accentColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing])
        .padding(.bottom, 10)
    }
}

