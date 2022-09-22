//
//  NoteListItem.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/21/22.
//

import Foundation
import SwiftUI

struct NoteListItem: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    var note: Note

    @Binding var isEditing: Bool
    @Binding var selectedNotes: [ObjectIdentifier]
    
    var isFirst: Bool
    var isLast: Bool
    var isOnly: Bool
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/y"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        if note.body != nil {
            HStack {
                let str = note.body!
                
                HStack(alignment: .center) {
                    if isEditing {
                        Button(action: {
                            if !selectedNotes.contains(note.id) {
                                selectedNotes.append(note.id)
                            } else {
                                selectedNotes = selectedNotes.filter { $0 != note.id }
                            }
                        }) {
                            if !selectedNotes.contains(note.id) {
                                Image(systemName: "circle")
                                    .font(.system(size: 18))
                                    .foregroundColor(.accentColor)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }

                    NavigationLink(destination: Notepad(note: note)) {
                        VStack(alignment: .leading) {
                            Text(str.count > 72 ? str.prefix(72) + "..." : str)
                                .foregroundColor(.primary)
                                .padding(.bottom, 1)
                                .multilineTextAlignment(.leading)
                            
                            Text(formatDate(date: note.createdAt!))
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 14))
                            
                        }

                        Spacer()

                        if !isEditing {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray5))
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(useDarkMode ? Color(.systemGray6) : .white)
                .cornerRadius(8, corners: [
                    isOnly
                        ? [.topLeft, .topRight, .bottomLeft, .bottomRight]
                        : isFirst
                            ? [.topLeft, .topRight]
                            : isLast
                                ? [.bottomLeft, .bottomRight]
                                : []
                    ]
                )
            }
        }
    }
}
