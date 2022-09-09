//
//  NotepadToolbar.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI
import PhotosUI

struct NotepadToolbar: View {
    @Binding var showGearSheet: Bool
    @Binding var showDataSheet: Bool

    @Binding var selectedImages: [PhotosPickerItem]
    @Binding var selectedPhotosData: Set<UIImage>

    var body: some View {
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

            Button(action: {
                showGearSheet.toggle()
            }) {
                Image(systemName: "backpack")
            }
            
//            Spacer()

//            Button(action: {
//                showDataSheet.toggle()
//            }) {
//                Image(systemName: "chart.pie")
//            }
        }
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 15)
        .padding([.leading, .trailing], 30)
        .background(.ultraThickMaterial)
    }
}
