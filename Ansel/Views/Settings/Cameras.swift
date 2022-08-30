//
//  Cameras.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/30/22.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    
    var camera: Camera?
    var delete: (Camera) -> Void

    @State private var manufacturer: String = ""
    @State private var model: String = ""
    @State private var notes: String = ""
    @State private var digital: Bool = false
    @State private var bulbMode: Bool = false
    
    @State private var presentAlert: Bool = false
    
    func save() -> Void {
        let target = camera ?? Camera(context: managedObjectContext)

        target.manufacturer = manufacturer
        target.model = model
        target.digital = digital
        target.bulbMode = bulbMode
        
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
                TextField("Model e.g M-10", text: $model)
                TextField("Notes", text: $notes)
            }
            
            Section {
                Toggle("Digital", isOn: $digital)
                    .toggleStyle(SwitchToggleStyle(tint: userAccentColor))
                Toggle("Bulb Mode", isOn: $bulbMode)
                    .toggleStyle(SwitchToggleStyle(tint: userAccentColor))
            }
            
            if camera != nil {
                Section {
                    Button(action: {
                        presentAlert.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Text("Delete Emulsion")
                            Spacer()
                        }
                    }
                    .foregroundColor(Color(.systemRed))
                }
            }
        }
        .confirmationDialog("Delete Camera?", isPresented: $presentAlert) {
            Button("Delete", role: .destructive) {
                delete(camera!)
                saveContext()
            }
        } message: {
            Text("Delete this camera? This action cannot be undone.")
          }
        .onAppear {
            if camera != nil && camera?.manufacturer != nil && camera?.model != nil {
                manufacturer = camera!.manufacturer!
                model = camera!.model!
                notes = camera!.notes ?? ""
                digital = camera!.digital
                bulbMode = camera!.bulbMode
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (
                    manufacturer.count > 0 &&
                    model.count > 0
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

struct AddCameraSheet: View {
    @Environment(\.presentationMode) var presentationMode

    func emptyFunc(_ camera: Camera) -> Void {}

    var body: some View {
        NavigationView {
            CameraView(delete: emptyFunc)
                .navigationTitle("Add Camera")
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

struct Cameras: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
      entity: Camera.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Camera.manufacturer, ascending: true)
      ]
    ) var fetchedResults: FetchedResults<Camera>
    
    @State private var showAddCameraSheet: Bool = false
    
    func deleteCamera(camera: Camera) -> Void {
        managedObjectContext.delete(camera)
    }

    var body: some View {
        VStack {
            if fetchedResults.isEmpty {
                VStack {
                    Spacer()
                    Text("Add a camera to get started")
                        .foregroundColor(Color(.systemGray))
                    Spacer()
                }
            } else {
                List {
                    ForEach(fetchedResults, id: \.self) { result in
                        NavigationLink(destination: CameraView(camera: result, delete: deleteCamera)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(result.manufacturer!)
                                        .font(.caption)
                                        .foregroundColor(Color(.systemGray))
                                    Text(result.model!)
                                }
                                .padding([.top, .bottom], 1)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Cameras")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddCameraSheet.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .foregroundColor(.accentColor)
            }
        }
        .sheet(isPresented: $showAddCameraSheet) {
            AddCameraSheet()
        }
    }
}
