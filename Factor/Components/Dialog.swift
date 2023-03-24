//
//  Dialog.swift
//  Factor
//
//  Created by Tyler Reckart on 3/24/23.
//

import Foundation
import SwiftUI

struct Dialog<Content: View>: View {
    @ViewBuilder var content: Content

    @Binding var open: Bool
    
    @State private var showOverlay: Bool = false
    @State private var showDialog: Bool = false
    
    var body: some View {
        ZStack {
            if (showOverlay) {
                Color.black.opacity(0.2)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            self.open.toggle()
                        }
                    }
            }
            
            if (showDialog) {
                VStack {
                    Spacer()
                    content
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
                        .padding(.horizontal)
                    Spacer()
                }
                .transition(.scale(scale: 0.4).combined(with: .opacity))
            }
        }
        .onChange(of: open) { newState in
            if (newState == true) {
                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.4, blendDuration: 1)) {
                    self.showDialog = newState
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.showDialog = newState
                }
            }
            
            withAnimation {
                self.showOverlay = newState
            }
        }
        .edgesIgnoringSafeArea(.all)
        .zIndex(2)
    }
}
