//
//  ContentView.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI
import CoreData

struct NavigationCard: View {
    var label: String
    var icon: String
    var gradient: [Int]

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .imageScale(.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
                .foregroundColor(.white)
            Text(label)
                .font(.system(.body))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .frame(height:125, alignment: .topLeading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: gradient[0]), Color(hex: gradient[1])]), startPoint: .top, endPoint: .bottom))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
        .cornerRadius(18)
    }
}

struct ContentView: View {
    var body: some View {
        return NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: BellowsExtension()) {
                        NavigationCard(
                            label: "Notes",
                            icon: "bookmark.circle.fill",
                            gradient: [0xffd100, 0xfba900]
                        )
                    }
                    
                    NavigationLink(destination: Reciprocity()) {
                        NavigationCard(
                            label: "Reciprocity",
                            icon: "moon.circle.fill",
                            gradient: [0x7035bf, 0x331c95]
                        )
                    }
                }
                
                HStack {
                    NavigationLink(destination: BellowsExtension()) {
                        NavigationCard(
                            label: "Bellows Extension Factor",
                            icon: "arrow.up.left.and.arrow.down.right.circle.fill",
                            gradient: [0x00c6ff, 0x0b75f8]
                        )
                    }
                    
                    NavigationLink(destination: BellowsExtension()) {
                        NavigationCard(
                            label: "Settings",
                            icon: "gear.circle.fill",
                            gradient: [0x4a4c4f, 0x434548]
                        )
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
