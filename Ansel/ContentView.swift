//
//  ContentView.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var url: String?

    var body: some View {
        Dashboard(url: url)
    }
}

