//
//  ContentView.swift
//  Factor
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI
import StoreKit

func incrementReviewCounter() -> Void {
    // If the app doesn't store the count, this returns 0.
    var count = UserDefaults.standard.integer(forKey: "sessionCount")
    count += 1
    UserDefaults.standard.set(count, forKey: "sessionCount")
    print("player session logged: \(count)")

    // Keep track of the most recent app version that prompts the user for a review.
    let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: "lastReviewedVersion")

    // Get the current bundle version for the app.
    let infoDictionaryKey = kCFBundleVersionKey as String
    guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
        else { fatalError("Expected to find a bundle version in the info dictionary.") }
     // Verify the user completes the process several times and doesn’t receive a prompt for this app version.
     if count >= 5 && currentVersion != lastVersionPromptedForReview {
         let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
         
         if (windowScene != nil) {
             SKStoreReviewController.requestReview(in: windowScene!)
             UserDefaults.standard.set(currentVersion, forKey: "lastReviewedVersion")
         }
     }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    init() { incrementReviewCounter() }
    
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

