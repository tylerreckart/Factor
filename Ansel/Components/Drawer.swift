//
//  Drawer.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/22/22.
//

import Foundation
import SwiftUI

struct DrawerContent: View {
    var body: some View {
        ZStack {
            Color.white
            
            ScrollView {
                HStack {
                    NotesCard(isDisabled: true)
                    ReciprocityFactorCard()
                }
                
                HStack {
                    BellowsExtensionFactorCard()
                    FilterFactorCard()
                }
            }
            .padding()
        }
    }
}

struct Drawer: View {
    private let height = UIScreen.main.bounds.height - 500

    @Binding var isOpen: Bool
    
    @State var ypos: CGFloat = 1000
    
    var body: some View {
        ZStack {


            VStack {
                Spacer()

                DrawerContent()
                    .frame(height: self.height)
                    .offset(y: ypos)
                    .cornerRadius(24, corners: [.topLeft, .topRight])
                    .shadow(color: Color.black.opacity(0.25), radius: 24, x: 0, y: -12)
                    .animation(.easeInOut(duration: 0.75), value: ypos)
                    .onAppear {
                        ypos = 0 // Trigger the animation to start
                    }
            }
        }
    }
}
