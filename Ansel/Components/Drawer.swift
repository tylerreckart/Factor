//
//  Drawer.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/22/22.
//

import Foundation
import SwiftUI

struct DrawerContent: View {
    @State var isEditing: Bool = false
    @State var isDragging: Bool = false

    var body: some View {
        ZStack {
            Color.white
            
            ScrollView {
                HStack {
                    NotesCard(isDisabled: true, isEditing: $isEditing, isDragging: $isDragging)
                    ReciprocityFactorCard(isDisabled: true, isEditing: $isEditing, isDragging: $isDragging)
                }
                
                HStack {
                    BellowsExtensionFactorCard(isDisabled: true, isEditing: $isEditing, isDragging: $isDragging)
                    FilterFactorCard(isDisabled: true, isEditing: $isEditing, isDragging: $isDragging)
                }
            }
            .padding()
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct Drawer: View {
    private let height = UIScreen.main.bounds.height - 550

    @Binding var isOpen: Bool
    var animationDuration: Double = 0.5
    
    @State var opacity: CGFloat = 0
    @State var ypos: CGFloat = 1000

    func dismissDrawer() -> Void {
        opacity = 0
        ypos = 1000

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            isOpen.toggle()
        }
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .opacity(opacity)
                .blur(radius: 20)
                .onAppear {
                    opacity = 0.2
                }
                .animation(.easeInOut(duration: animationDuration), value: opacity)
                .onTapGesture {
                    dismissDrawer()
                }

            VStack {
                Spacer()

                DrawerContent()
                    .frame(height: self.height)
                    .offset(y: ypos)
                    .cornerRadius(24, corners: [.topLeft, .topRight])
                    .shadow(color: Color.black.opacity(0.25), radius: 24, x: 0, y: -12)
                    .animation(.easeInOut(duration: animationDuration), value: ypos)
                    .onAppear {
                        ypos = 0 // Trigger the animation to start
                    }
            }
        }
    }
}
