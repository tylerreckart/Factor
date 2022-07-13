//
//  Notes.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/12/22.
//

import SwiftUI


struct NoteList: View {
    let array = ["Peter", "Paul", "Mary", "Anna-Lena", "George", "John", "Greg", "Thomas", "Robert", "Bernie", "Mike", "Benno", "Hugo", "Miles", "Michael", "Mikel", "Tim", "Tom", "Lottie", "Lorrie", "Barbara"]
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        print("onCommit")
                    }).foregroundColor(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton  {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
    
            List {
                VStack {
                    Text("Title")
                        .font(.system(.headline).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("12/25/25")
                        Text("There once was a pirate...")
                            .foregroundColor(Color(.gray))
                        Spacer()
                    }
                }

                VStack {
                    Text("Title")
                        .font(.system(.headline).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("12/25/25")
                        Text("There once was a pirate...")
                            .foregroundColor(Color(.gray))
                        Spacer()
                    }
                }
            }
            .resignKeyboardOnDragGesture()
            .listStyle(.plain)
            .toolbar {
                Label("History", systemImage: "square.and.pencil")
                    .foregroundColor(Color(.systemBlue))
            }
        }
    }
}


struct Notes: View {
    var body: some View {
        NoteList()
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
    }
}

struct Notes_Previews: PreviewProvider {
    static var previews: some View {
        Notes()
    }
}
