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
    }
}

struct NotesCard: View {
    var isDisabled: Bool = false

    var body: some View {
        NavigationCard(
            label: "Notes",
            icon: "bookmark.circle.fill",
            background: Color(.systemYellow),
            isDisabled: isDisabled
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
        .tabItem {
            Label("Received", systemImage: "tray.and.arrow.down.fill")
        }
    }
}

struct ReciprocityFactorCard: View {
    var isDisabled: Bool = false

    var body: some View {
        NavigationCard(
            label: "Reciprocity Factor",
            icon: "clock.circle.fill",
            background: Color(.systemPurple),
            isDisabled: isDisabled
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct BellowsExtensionFactorCard: View {
    var isDisabled: Bool = false

    var body: some View {
        NavigationCard(
            label: "Bellows Extension Factor",
            icon: "arrow.up.left.and.arrow.down.right.circle.fill",
            background: Color(.systemBlue),
            isDisabled: isDisabled
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct FilterFactorCard: View {
    var isDisabled: Bool = false

    var body: some View {
        NavigationCard(
            label: "Filter Factor",
            icon: "moon.circle.fill",
            background: Color(.systemGreen),
            isDisabled: isDisabled
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}

struct Home: View {
    @Binding var drawerToggle: Bool

    var body: some View {
        return NavigationView {
            VStack {
                Text("Field Tools")
                    .font(.system(.caption))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    .padding(.top)

                HStack {
                    NavigationLink(destination: Notes()) {
                        NotesCard()
                    }
                }
                
                Text("Exposure Compensation Tools")
                    .font(.system(.caption))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    .padding(.top)
                
                HStack {
                    NavigationLink(destination: Reciprocity()) {
                        ReciprocityFactorCard()
                    }

                    NavigationLink(destination: BellowsExtension()) {
                        BellowsExtensionFactorCard()
                    }
                }
                
                HStack {
                    NavigationLink(destination: FilterFactor()) {
                        FilterFactorCard()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Ansel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HStack {
                    Button(action: {
                        self.drawerToggle.toggle()
                    }) {
                        Label("Edit Dashboard", systemImage: "slider.vertical.3")
                    }
                    
                    Button(action: {
                        self.drawerToggle.toggle()
                    }) {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
                .foregroundColor(Color(.systemBlue))
            }
            .background(Color(.systemGray6))
        }
    }
}

struct ContentView: View {
    @State private var isDrawerOpen: Bool = false

    var body: some View {
        ZStack {
            Home(drawerToggle: $isDrawerOpen)
            
            if isDrawerOpen {
                Drawer(isOpen: $isDrawerOpen).edgesIgnoringSafeArea(.vertical)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
