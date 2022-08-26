//
//  Notes.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/12/22.
//

import SwiftUI
import PhotosUI

struct NewNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var noteBody: String = ""
    
    @State var showReciprocitySheet: Bool = false
    @State var showFilterSheet: Bool = false
    @State var showBellowsSheet: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: [Data] = []
    
    enum FocusField: Hashable {
      case noteBody
    }

    @FocusState private var focusedField: FocusField?

    var body: some View {
        VStack {
            VStack {
                TextField("Start typing...", text: $noteBody)
                    .zIndex(1)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .noteBody)
                    .onAppear {
                        self.focusedField = .noteBody
                    }


                Spacer()
            }
            .toolbar {
                HStack {
                    Menu {
                        PhotosPicker(
                            selection: $selectedImages,
                            matching: .images
                        ) {
                            Label("Add Images", systemImage: "photo")
                        }
                        .onChange(of: selectedImages) { newItems in
                            for newItem in newItems {
                                Task {
                                    if let data = try? await newItem.loadTransferable(type:Data.self) {
                                        selectedPhotosData.append(data)
                                    }
                                }
                            }
                        }

                        Button(action: {
                            showReciprocitySheet.toggle()
                        }) {
                            Label("Add Reciprocity Data", systemImage: "clock")
                        }
                        
                        Button(action: {
                            showFilterSheet.toggle()
                        }) {
                            Label("Add Filter Data", systemImage: "moon.stars.circle")
                        }

                        Button(action: {
                            showBellowsSheet.toggle()
                        }) {
                            Label("Add Bellows Data", systemImage: "arrow.up.backward.and.arrow.down.forward.circle")
                        }
                    }
                    label: {
                        Label("Add Data", systemImage: "ellipsis.circle")
                    }

                    Button(action: {
                        save()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
                }
            }
            .padding([.top, .leading, .trailing])
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showReciprocitySheet) {
                ReciprocityHistorySheet()
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterHistorySheet()
            }
            .sheet(isPresented: $showBellowsSheet) {
                BellowsExtensionHistorySheet()
            }
        }
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func save() {
        let newNote = Note(context: managedObjectContext)

        newNote.body = self.noteBody
        newNote.createdAt = Date()

        saveContext()
    }
}

struct NoteView: View {
    var note: Note

    var body: some View {
        VStack {
            Text(note.body!)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct NoteList: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var showNewNoteSheet: Bool = false
    
    @FetchRequest(
      entity: Note.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)
      ]
    ) var results: FetchedResults<Note>

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
                .padding(EdgeInsets(top: 8, leading: 6, bottom: showCancelButton ? 6 : 10, trailing: 6))
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
                ForEach(results, id: \.self) { r in
                    NavigationLink(destination: NoteView(note: r)) {
                        VStack {
                            HStack {
                                Text(r.body!)
                                    .font(.system(.headline).bold())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(formatDate(date: r.createdAt!))
                                    .foregroundColor(Color(.systemBlue))
                            }
                            .padding(.bottom, 1)
                            
                            HStack {
                                Text(r.body!)
                                    .foregroundColor(Color(.gray))
                                Spacer()
                            }
                            
                        }
                    }
                }
                .onDelete { indexSet in
                    do{
                        try indexSet.forEach { i in
                            self.managedObjectContext.delete(results[i])
                            self.managedObjectContext.refreshAllObjects()
                            try self.managedObjectContext.save()
                        }
                    }catch{
                        print(error)
                    }
                }
                .padding(.vertical, 4)
            }
            .resignKeyboardOnDragGesture()
            .listStyle(.plain)
            .toolbar {
                NavigationLink(destination: NewNote()) {
                    Label("New Note", systemImage: "square.and.pencil")
                }
                .foregroundColor(.accentColor)
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/y"
        return dateFormatter.string(from: date)
    }
    
    private func deleteNote(note: Note){
            managedObjectContext.delete(note)
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
    }
}


struct Notes: View {
    var body: some View {
        NoteList()
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct Notes_Previews: PreviewProvider {
    static var previews: some View {
        Notes()
    }
}
