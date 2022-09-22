//
//  Notes.swift
//  Aspen
//
//  Created by Tyler Reckart on 7/12/22.
//

import SwiftUI

struct Notes: View {
    var body: some View {
        NoteList()
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
    }
}
