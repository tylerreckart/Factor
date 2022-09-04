//
//  CameraData.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI

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

