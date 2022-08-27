//
//  Note.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct NoteView: View {
    var note: Note

    var body: some View {
        VStack {
            Text(note.body!)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if note.bellowsData != nil {
                ForEach(Array(note.bellowsData as! Set<BellowsExtensionData>), id: \.self) { result in
                    BellowsData(result: result)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    }
}
