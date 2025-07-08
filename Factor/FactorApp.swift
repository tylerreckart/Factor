//
//  FactorApp.swift
//  Factor
//
//  Created by the Factor Contributors.
//

import SwiftUI

@main
struct FactorApp: App {
    let persistenceController = PersistenceController.shared

    @AppStorage("useDarkMode") var useDarkMode: Bool?
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(useDarkMode == true ? .dark : .light)
                .accentColor(userAccentColor)
                .fontDesign(.rounded)
        }
    }
}
