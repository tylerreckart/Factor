//
//  LumenApp.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI

@main
struct LumenApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
