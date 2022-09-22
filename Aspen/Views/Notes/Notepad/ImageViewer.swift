//
//  ImageViewer.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/31/22.
//

import Foundation
import UIKit
import SwiftUI

struct ImageViewer: View {
    var image: UIImage
    var dismiss: () -> Void
    
    @State private var animate: Bool = false
    
    func dismissView() {
        animate = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            dismiss()
        }
    }

    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(0)
                .overlay(.thinMaterial)
                .opacity(animate ? 1 : 0)
                .animation(.linear(duration: 0.25), value: animate)
                .onTapGesture {
                    dismissView()
                }
            
            Image(uiImage: image)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fit)
                .padding(animate ? 0 : 10)
                .opacity(animate ? 1 : 0)
                .animation(.linear(duration: 0.25), value: animate)
        }
        .onAppear {
            animate = true
        }
    }
}
