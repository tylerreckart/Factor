//
//  TileTrashBin.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI

struct TileTrashBin: View {
    @Binding var isDragging: Bool
    @Binding var isDrawerOpen: Bool
    @Binding var shouldRemoveTile: Bool
    
    @State var scale: CGFloat = 1
    @State var ypos: CGFloat = 1000
    @State var opacity: CGFloat = 0

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                if isDragging {
                    Rectangle().fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(.systemGray6).opacity(0), .black.opacity(0.4)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .offset(y: ypos)
                    .animation(.easeInOut(duration: 0.25), value: ypos)
                }

                HStack {
                    Spacer()

                    Button(action: {
                        isDrawerOpen = true
                    }) {
                        Label("", systemImage: "trash.circle")
                            .foregroundColor(.white)
                            .offset(y: ypos)
                            .animation(.easeInOut(duration: 0.5), value: ypos)
                            .onChange(of: isDragging) { newState in
                                if !isDragging {
                                    ypos = 1000
                                } else {
                                    ypos = 0
                                }
                            }
                            .scaleEffect(scale)
                            .onChange(of: shouldRemoveTile) { newState in
                                if shouldRemoveTile {
                                    scale = 1.2
                                } else {
                                    scale = 1
                                }
                            }
                            .animation(.easeInOut(duration: 0.1), value: scale)
                    }
                    .font(.title)

                    Spacer()
                }
            }
            .frame(height: 200)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
