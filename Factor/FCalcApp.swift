//
//  FactorApp.swift
//  Factor
//
//  Created by Tyler Reckart on 7/9/22.
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
        }
    }
}
