//
//  FCalcApp.swift
//  FCalc
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI

@main
struct FCalcApp: App {
    @AppStorage("useDarkMode") var useDarkMode: Bool?
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    let persistenceController = PersistenceController.shared
    
    @State private var url: String?

    var body: some Scene {
        WindowGroup {
            ContentView(url: $url)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(useDarkMode == true ? .dark : .light)
                .accentColor(userAccentColor)
                .onOpenURL { incoming in
                    guard incoming.scheme == "FCalc" else { return }
                    url = incoming.absoluteString
                }
        }
    }
}
