//
//  SearchBar.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/21/22.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    @Binding var searchText: String
    
    @State private var showCancelButton: Bool = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                    withAnimation {
                        showCancelButton = true
                    }
                }).foregroundColor(.primary)
                
                Spacer()
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(useDarkMode ? Color(.systemGray6) : .white)
            .cornerRadius(8)

            if showCancelButton  {
                Button("Cancel") {
                    withAnimation {
                        UIApplication.shared.endEditing(true)
                        searchText = ""
                        showCancelButton = false
                    }
                }
                .foregroundColor(.accentColor)
            }
        }
    }
}
