//
//  Lenss.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/30/22.
//

import SwiftUI

struct LensView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    
    var lens: Lens?
    var delete: (Lens) -> Void

    @State private var manufacturer: String = ""
    @State private var focalLength: String = ""
    @State private var maximumAperture: Double = 2.8
    @State private var notes: String = ""
    
    @State private var showApertureMenu: Bool = false
    @State private var presentAlert: Bool = false
    
    func save() -> Void {
        let target = lens ?? Lens(context: managedObjectContext)

        target.manufacturer = manufacturer
        target.focalLength = Int32(focalLength)!
        target.maximumAperture = maximumAperture
        
        if notes.count > 0 {
            target.notes = notes
        }

        saveContext()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()

            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    var body: some View {
        List {
            Section {
                TextField("Manufacturer e.g Leica", text: $manufacturer)
                TextField("Focal Length", text: $focalLength)
                TextField("Notes", text: $notes)
            }
            
            Section {
                Button(action: {
                    showApertureMenu.toggle()
                }) {
                    HStack {
                        Text("Maximum Aperture")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(maximumAperture.clean)")
                            .foregroundColor(Color(.systemGray))
                            .padding(.trailing, 1)
                        
                        if !showApertureMenu {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                
                if showApertureMenu {
                    Picker("Maximum Aperture", selection: $maximumAperture) {
                        ForEach(f_stops, id: \.self) { opt in
                            Text("\(opt.clean)")
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            
            if lens != nil {
                Section {
                    Button(action: {
                        presentAlert.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Text("Delete Lens")
                            Spacer()
                        }
                    }
                    .foregroundColor(Color(.systemRed))
                }
            }
        }
        .confirmationDialog("Delete Lens?", isPresented: $presentAlert) {
            Button("Delete", role: .destructive) {
                delete(lens!)
                saveContext()
            }
        } message: {
            Text("Delete this camera? This action cannot be undone.")
          }
        .onAppear {
            if lens != nil && lens?.manufacturer != nil && lens?.focalLength != nil {
                manufacturer = lens!.manufacturer!
                focalLength = String(lens!.focalLength)
                notes = lens!.notes ?? ""
                maximumAperture = lens!.maximumAperture
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (
                    manufacturer.count > 0 &&
                    focalLength.count > 0
                ) {
                    Button(action: {
                        save()
                    }) {
                        Text("Save")
                    }
                    .foregroundColor(.accentColor)
                } else {
                    Text("Save")
                        .foregroundColor(Color(.systemGray))
                }
            }
        }
    }
}

struct AddLensSheet: View {
    @Environment(\.presentationMode) var presentationMode

    func emptyFunc(_ camera: Lens) -> Void {}

    var body: some View {
        NavigationView {
            LensView(delete: emptyFunc)
                .navigationTitle("Add Lens")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                }
        }
    }
}

struct Lenses: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
      entity: Lens.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Lens.manufacturer, ascending: true)
      ]
    ) var fetchedResults: FetchedResults<Lens>
    
    @State private var showAddLensSheet: Bool = false
    
    func deleteLens(camera: Lens) -> Void {
        managedObjectContext.delete(camera)
    }

    var body: some View {
        VStack {
            if fetchedResults.isEmpty {
                VStack {
                    Spacer()
                    Text("Add a lens to get started")
                        .foregroundColor(Color(.systemGray))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
            } else {
                List {
                    ForEach(fetchedResults, id: \.self) { result in
                        NavigationLink(destination: LensView(lens: result, delete: deleteLens)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(result.manufacturer!)
                                        .font(.caption)
                                        .foregroundColor(Color(.systemGray))
                                    Text("\(result.focalLength)mm f/\(result.maximumAperture.clean)")
                                }
                                .padding([.top, .bottom], 1)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Lenses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddLensSheet.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .foregroundColor(.accentColor)
            }
        }
        .sheet(isPresented: $showAddLensSheet) {
            AddLensSheet()
        }
    }
}
