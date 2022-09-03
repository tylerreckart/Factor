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
    @State private var presentError: Bool = false
    
    func validate() -> NewLensState? {
        var target = NewLensState()
        
        do {
            target.manufacturer = manufacturer
            target.maximumAperture = maximumAperture

            if notes.count > 0 {
                target.notes = notes
            }
    
            if focalLength.contains("mm") {
                let arr = focalLength.split(separator: "mm")
                let asInt = try convertToInt32(String(arr[0]))
                target.focalLength = asInt!
            } else {
                let asInt = try convertToInt32(focalLength)
                target.focalLength = asInt!
            }
            
            return target
        } catch {
            presentError = true
        }
        
        return nil
    }
    
    func save(target: NewLensState) -> Void {
        let newLens = lens ?? Lens(context: managedObjectContext)
        
        newLens.manufacturer = target.manufacturer
        newLens.maximumAperture = maximumAperture
        if focalLength.contains("mm") {
            let arr = focalLength.split(separator: "mm")
            newLens.focalLength = Int32(String(arr[0]))!
        } else {
            let asInt = Int32(focalLength)!
            newLens.focalLength = asInt
        }
        newLens.notes = target.notes ?? ""
        
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
                TextField("Focal Length (mm)", text: $focalLength)
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
        .alert(isPresented: $presentError, error: ValidationError.NaN) {_ in
            Button(action: {
                presentError = false
            }) {
                Text("Ok")
            }
        } message: { error in
            Text("Unable to process focal length. Please try again.")
        }
        .confirmationDialog("Delete Lens?", isPresented: $presentAlert) {
            Button("Delete", role: .destructive) {
                delete(lens!)
                saveContext()
            }
        } message: {
            Text("Delete this lens? This action cannot be undone.")
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(Color(.systemGray))
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if (
                    manufacturer.count > 0 &&
                    focalLength.count > 0
                ) {
                    Button(action: {
                        let obj = validate()

                        if obj != nil {
                            save(target: obj!)
                        }
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
    
    func deleteLens(lens: Lens) -> Void {
        managedObjectContext.delete(lens)
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
