//
//  NoteGroup.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/21/22.
//

import Foundation
import SwiftUI

struct NoteGroup: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    var group: [Note]
    var month: String
    
    @Binding var isEditing: Bool
    @Binding var selectedNotes: [ObjectIdentifier]

    var body: some View {
        Section(header:
            HStack {
                Text(month)
                    .textCase(.none)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading)
                Spacer()
            }
        ) {
            VStack(spacing: 0) {
                ForEach(Array(group.enumerated()), id: \.element) { index, element in
                    NoteListItem(
                        note: element,
                        isEditing: $isEditing,
                        selectedNotes: $selectedNotes,
                        isFirst: index == 0,
                        isLast: index == (group.count - 1),
                        isOnly: group.count == 1
                    )
                    
                    if index != (group.count - 1) {
                        Divider()
                            .overlay(Color(.systemGray4))
                            .overlay(HStack { Color(useDarkMode ? .systemGray6 : .white).frame(maxWidth: 15); Spacer() })
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
