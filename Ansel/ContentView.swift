//
//  ContentView.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI

struct NavigationCard: View {
    var label: String
    var icon: String
    var background: Color
    var isDisabled: Bool = false
    
    @Binding var isEditing: Bool
    
    var rowIndex: Int = 1
    
    @State private var xpos: CGFloat = 0
    @State private var ypos: CGFloat = 0
    
    @Binding var isDragging: Bool

    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true

                xpos = value.translation.width
                ypos = value.translation.height
            }
            .onEnded { value in
                isDragging = false

                if value.location.y > 400 {
                    // TODO: Remove the tile from the dashboard
                    let i = 0
                } else {
                    ypos = 0
                    xpos = 0
                }
            }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .imageScale(.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text(label)
                .font(.system(.body))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
        .padding()
        .foregroundColor(isDisabled ? Color(.systemGray) : .white)
        .background(isDisabled ? Color(.systemGray4) : background)
        .cornerRadius(18)
        .rotationEffect(.degrees(isEditing ? (self.rowIndex % 2 == 0 ? 1.25 : -1.25) : 0))
        .animation(isEditing ? .easeInOut(duration: 0.15).repeatForever(autoreverses: true) : .default, value: isEditing)
        .offset(x: xpos, y: ypos)
        .gesture(isEditing ? simpleDrag : nil)
        .zIndex(isDragging ? 10 : 1)
    }
}

struct NotesCard: View {
    var isDisabled: Bool = false
    
    @Binding var isEditing: Bool
    
    var rowIndex = 1
    
    @Binding var isDragging: Bool

    var body: some View {
        NavigationCard(
            label: "Notes",
            icon: "bookmark.circle.fill",
            background: Color(.systemYellow),
            isDisabled: isDisabled,
            isEditing: $isEditing,
            rowIndex: rowIndex,
            isDragging: $isDragging
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct ReciprocityFactorCard: View {
    var isDisabled: Bool = false
    
    @Binding var isEditing: Bool
    
    var rowIndex = 1
    
    @Binding var isDragging: Bool

    var body: some View {
        NavigationCard(
            label: "Reciprocity Factor",
            icon: "clock.circle.fill",
            background: Color(.systemPurple),
            isDisabled: isDisabled,
            isEditing: $isEditing,
            rowIndex: rowIndex,
            isDragging: $isDragging
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct BellowsExtensionFactorCard: View {
    var isDisabled: Bool = false
    
    @Binding var isEditing: Bool
    
    var rowIndex = 1
    
    @Binding var isDragging: Bool

    var body: some View {
        NavigationCard(
            label: "Bellows Extension Factor",
            icon: "arrow.up.left.and.arrow.down.right.circle.fill",
            background: Color(.systemBlue),
            isDisabled: isDisabled,
            isEditing: $isEditing,
            rowIndex: rowIndex,
            isDragging: $isDragging
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct FilterFactorCard: View {
    var isDisabled: Bool = false

    @Binding var isEditing: Bool
    
    var rowIndex = 1
    
    @Binding var isDragging: Bool

    var body: some View {
        NavigationCard(
            label: "Filter Factor",
            icon: "moon.circle.fill",
            background: Color(.systemGreen),
            isDisabled: isDisabled,
            isEditing: $isEditing,
            rowIndex: rowIndex,
            isDragging: $isDragging
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct NavigationCardTile: View {
    var tile: DashboardTile
    var isDisabled: Bool = false
    var rowIndex: Int = 1

    @Binding var isEditing: Bool
    @Binding var isDragging: Bool

    var body: some View {
        NavigationLink(destination: AnyView(tile.destination)) {
            NavigationCard(
                label: tile.label,
                icon: tile.icon,
                background: tile.background,
                isDisabled: isDisabled,
                isEditing: $isEditing,
                rowIndex: rowIndex,
                isDragging: $isDragging
            )
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
        }
    }
}

struct Home: View {
    @Binding var isDrawerOpen: Bool
    @Binding var isDragging: Bool

    @State private var isEditing: Bool = false
    @State private var dashboardLayout = [
        DashboardTile(key: "notes", label: "Notes", icon: "bookmark.circle.fill", background: Color(.systemYellow), destination: AnyView(Notes())),
        DashboardTile(key: "reciprocity_factor", label: "Reciprocity Factor", icon: "bookmark.circle.fill", background: Color(.systemPurple), destination: AnyView(Reciprocity())),
        DashboardTile(key: "bellows_extension_factor", label: "Bellows Extension Factor", icon: "bookmark.circle.fill", background: Color(.systemBlue), destination: AnyView(BellowsExtension())),
        DashboardTile(key: "filter_factor", label: "Filter Factor", icon: "bookmark.circle.fill", background: Color(.systemGreen), destination: AnyView(FilterFactor())),
    ]
    
    func removeTile(id: String) -> Void {
        dashboardLayout = dashboardLayout.filter({ $0.id != id })
    }

    var body: some View {
        return NavigationView {
            VStack {
                ForEach(Array(stride(from: 0, to: self.dashboardLayout.count, by: 2)), id: \.self) { index in
                    let tile = dashboardLayout[index]
                    let nextTile = dashboardLayout[index + 1]

                    HStack {
                        NavigationCardTile(
                            tile: tile,
                            isEditing: $isEditing,
                            isDragging: $isDragging
                        )
                        
                        NavigationCardTile(
                            tile: nextTile,
                            isEditing: $isEditing,
                            isDragging: $isDragging
                        )
                    }
                }

                Spacer()
                
                if isEditing {
                    ZStack {
                        HStack {
                            Button(action: {
                                isDrawerOpen = true
                            }) {
                                Label("Add Tiles", systemImage: "plus.app")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                isEditing = false
                            }) {
                                Label("Done", systemImage: "")
                            }
                        }

                    }
                }
            }
            .padding()
            .navigationTitle("Ansel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Label("Edit Dashboard", systemImage: "slider.vertical.3")
                    }
                    .foregroundColor(Color(.systemBlue))
                }
                    
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .background(Color(.systemGray6))
        }
    }
}

struct ContentView: View {
    @State private var isDrawerOpen: Bool = false
    @State private var isDragging: Bool = false
    
    var body: some View {
        ZStack {
            Home(isDrawerOpen: $isDrawerOpen, isDragging: $isDragging)
            
            if isDrawerOpen {
                Drawer(isOpen: $isDrawerOpen).edgesIgnoringSafeArea(.vertical)
            }
            
            if isDragging {
                VStack {
                    Spacer()

                    ZStack {
                        Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color(.systemGray6).opacity(0), .black.opacity(0.4)]), startPoint: .top, endPoint: .bottom))

                        HStack {
                            Spacer()

                            Button(action: {
                                isDrawerOpen = true
                            }) {
                                Label("", systemImage: "trash.circle.fill")
                                    .foregroundColor(Color(.white))
                            }
                            .font(.title)

                            Spacer()
                        }
                    }
                    .frame(height: 200)
                }
                .edgesIgnoringSafeArea(.bottom)
                .zIndex(2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
