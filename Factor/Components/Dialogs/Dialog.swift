//
//  Dialog.swift
//  Factor
//
//  Created by Tyler Reckart on 3/24/23.
//

import Foundation
import SwiftUI

struct Dialog<Content: View, CalculatedContent: View>: View {
    @ViewBuilder var content: Content
    @ViewBuilder var calculatedContent: CalculatedContent

    @Binding var open: Bool
    @Binding var calculated: Bool
    
    @State private var showOverlay: Bool = false
    @State private var showDialog: Bool = false
    @State private var showCalculatedContent: Bool = false
    
    var body: some View {
        ZStack {
            if (showOverlay) {
                Color.black.opacity(0.2)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            self.open.toggle()
                            self.calculated = false
                        }
                    }
            }
            
            VStack(spacing: 20) {
                if (showDialog) {
                    content
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.thickMaterial)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
                        .padding(.horizontal)
                        .transition(.scale(scale: 0.4).combined(with: .opacity))
                }
                
                if (showCalculatedContent) {
                    calculatedContent
                        .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
                        .padding(.horizontal)
                        .transition(
                            .asymmetric(
                                insertion: .push(from: .bottom),
                                removal: .push(from: .top)
                           )
                        )
                }
                
                Spacer()
            }
            .padding(.top, 16)
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
        .onChange(of: calculated) { newState in
            if (newState == true) {
                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.4, blendDuration: 1)) {
                    self.showCalculatedContent = newState
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.showCalculatedContent = newState
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
