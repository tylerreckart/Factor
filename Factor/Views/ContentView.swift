//
//  ContentView.swift
//  Factor
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    func seed() -> Void {
        let userDefaults = UserDefaults.standard
        let defaultValues = ["firstRun" : true, "seeded": false]

        userDefaults.register(defaults: defaultValues)
        
        if userDefaults.bool(forKey: "firstRun") && !userDefaults.bool(forKey: "seeded") {
            seedEmulsions(context: managedObjectContext)
        }
    }

    var body: some View {
        Dashboard().onAppear { seed() }
    }
}

