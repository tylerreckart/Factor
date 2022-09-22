//
//  Dashboard.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct DroppableTileDelegate<DashboardTile: Equatable>: DropDelegate {
    let tile: DashboardTile
    var listData: [DashboardTile]

    @Binding var current: DashboardTile?
    @Binding var hasLocationChanged: Bool
    
    var moveAction: (IndexSet, Int) -> Void
    
    func dropEntered(info: DropInfo) {
        guard tile != current, let current = current else { return }
        guard let from = listData.firstIndex(of: current), let to = listData.firstIndex(of: tile) else { return }
        
        hasLocationChanged = true
        
        if listData[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        hasLocationChanged = false
        current = nil
        return true
    }
}

struct DashboardTileView<Content: View, DashboardTile: Identifiable & Equatable>: View {
    @Binding var tiles: [DashboardTile]
    let content: (DashboardTile) -> Content
    let moveAction: (IndexSet, Int) -> Void
    
    @Binding var draggingTile: DashboardTile?

    @State private var hasLocationChanged: Bool = false
    
    init(
        tiles: Binding<[DashboardTile]>,
        draggingTile: Binding<DashboardTile?>,
        @ViewBuilder content: @escaping (DashboardTile) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self._tiles = tiles
        self.content = content
        self.moveAction = moveAction
        self._draggingTile = draggingTile
    }
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            ForEach(tiles) { tile in
                VStack {
                    content(tile)
                        .overlay(
                            draggingTile == tile
                            ? RoundedRectangle(cornerRadius: 17).fill(.thinMaterial)
                            : nil
                        )
                        .onDrag {
                            draggingTile = tile
                            return NSItemProvider(object: "\(tile.id)" as NSString)
                        } preview: {
                            content(tile)
                                .frame(minWidth: screenWidth - 20, minHeight: 80)
                                .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .onDrop(
                            of: [UTType.text],
                            delegate: DroppableTileDelegate(
                                tile: tile,
                                listData: tiles,
                                current: $draggingTile,
                                hasLocationChanged: $hasLocationChanged
                            ) { from, to in
                                withAnimation {
                                    moveAction(from, to)
                                }
                            }
                        )
                }
            }
        }
    }
}

struct Dashboard: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    var url: String?
    var store: Store?

    @AppStorage("userDashboardLayout") var dashboard: [String] = dashboard_tiles.map { $0.id }

    @State private var layout: [DashboardTile] = []
    @State private var activeTileIds: [String?] = []

    @State var isEditing: Bool = false
    @State var draggingTile: DashboardTile?
    
    @State var showTileSheet: Bool = false
    
    func removeTile(id: String) -> Void {
        layout = layout.filter { $0.key != id }

        dashboard = layout.map { $0.id }
    }
    
    func addTile(tile: DashboardTile) -> Void {
        layout.append(tile)

        dashboard = layout.map { $0.id }
    }
    
    func moveTile(_ from: IndexSet, _ to: Int) -> Void {
        layout.move(fromOffsets: from, toOffset: to)
        
        dashboard = layout.map { $0.id }
    }
    
    func getLayout() -> Void {
        var tiles: [DashboardTile] = []
    
        dashboard.forEach { id in
            tiles.append(dashboard_tiles.filter({ $0.id == id }).first!)
        }
        
        layout = tiles
    }
    
    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        return NavigationView {
            ZStack {
                VStack {
                    DashboardTileView(tiles: $layout, draggingTile: $draggingTile) { tile in
                        LinkedNavigationTile(
                            tile: tile,
                            isDisabled: false,
                            draggingTile: $draggingTile,
                            isEditing: $isEditing,
                            removeTile: removeTile,
                            url: url ?? "",
                            shouldNavigate: false
                        )
                    } moveAction: { from, to in
                        moveTile(from, to)
                    }
                    .padding()
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    DashboardToolbar(isEditing: $isEditing, showTileSheet: $showTileSheet)
                        .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Label("Edit Dashboard", systemImage: "slider.horizontal.2.square.on.square")
                        }

                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Settings(store: store)) {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                }
                .background(useDarkMode ? Color(.black) : Color(.systemGray6))
                .sheet(isPresented: $showTileSheet) {
                    TileSheet(addTile: addTile)
                }
                
                ZStack {
                    Image("aspen.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(.systemGray4))
                        .position(x: screenWidth / 2, y: -22)
                }
            }
        }
        .onAppear {
            getLayout()
        }
    }
}
