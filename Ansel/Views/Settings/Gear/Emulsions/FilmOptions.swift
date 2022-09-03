//
//  FilmOptions.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/30/22.
//

import SwiftUI
import CoreData

struct EmulsionView: View {
    @AppStorage("filmOptions") var defaultOptions: [String] = filmOptions.map { $0.id }

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    var emulsion: Emulsion?
    var delete: (Emulsion) -> Void
    
    @State private var manufacturer: String = ""
    @State private var name: String = ""
    @State private var notes: String = ""
    @State private var iso: Int32 = 50
    @State private var pFactor: String = ""
    @State private var threshold: String = ""
    
    @State private var showISOMenu: Bool = false
    
    @State private var emulsionState: Emulsion?
    
    @State private var presentAlert: Bool = false
    
    func save() -> Void {
        let target = emulsion ?? Emulsion(context: managedObjectContext)

        target.manufacturer = manufacturer
        target.name = name
        target.iso = iso
        
        if notes.count > 0 {
            target.notes = notes
        }
        
        if pFactor.count > 0 {
            target.pFactor = Double(pFactor)!
        }
        
        if threshold.count > 0 {
            target.threshold = Int32(threshold)!
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
                TextField("Manufacturer", text: $manufacturer)
                TextField("Name", text: $name)
                TextField("Notes", text: $notes)
            }
            
            Section {
                Button(action: {
                    showISOMenu.toggle()
                }) {
                    HStack {
                        Text("ISO Rating")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(iso)")
                            .foregroundColor(Color(.systemGray))
                            .padding(.trailing, 1)
                        
                        if !showISOMenu {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                
                if showISOMenu {
                    Picker("ISO", selection: $iso) {
                        ForEach(isos, id: \.self) { opt in
                            Text("\(opt)")
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            
            Section(
                header: Text("Reciprocity Failure").textCase(.none).font(.system(size: 12)),
                footer: Text("These values are used to calculate compensation for reciprocity failure. This emulsion will not be available for reciprocity calculation if these values are left empty.").font(.system(size: 12))
            ) {
                VStack(alignment: .leading) {
                    if pFactor.count > 0 {
                        Text("P-Factor")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                    }
                    TextField("P-Factor", text: $pFactor)
                }
                
                VStack(alignment: .leading) {
                    if pFactor.count > 0 {
                        Text("Threshold (seconds)")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                    }
                    TextField("Threshold", text: $threshold)
                }
            }
            
            if emulsion != nil {
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
        .onAppear {
            if emulsion != nil && emulsion?.manufacturer != nil && emulsion?.name != nil {
                manufacturer = emulsion!.manufacturer!
                name = emulsion!.name!
                iso = emulsion!.iso
                pFactor = String(emulsion!.pFactor)
                threshold = String(emulsion!.threshold)
                
                if emulsion!.notes != nil {
                    notes = emulsion!.notes!
                }
            }
        }
        .confirmationDialog("Delete Emulsion?", isPresented: $presentAlert) {
            Button("Delete", role: .destructive) {
                delete(emulsion!)
                saveContext()
            }
        } message: {
            Text("Delete this emulsion? This action cannot be undone.")
          }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (
                    manufacturer.count > 0 &&
                    name.count > 0 &&
                    iso != 0
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

struct AddEmulsionSheet: View {
    @Environment(\.presentationMode) var presentationMode

    func emptyFunc(_ emulsion: Emulsion) -> Void {}

    var body: some View {
        NavigationView {
            EmulsionView(delete: emptyFunc)
                .navigationTitle("Add Emulsion")
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

struct FilmStocks: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
      entity: Emulsion.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Emulsion.manufacturer, ascending: true)
      ]
    ) var fetchedResults: FetchedResults<Emulsion>

    @State private var showFilmSheet: Bool = false
    
    func seed() -> Void {
        let userDefaults = UserDefaults.standard
        let defaultValues = ["firstRun" : true, "seeded": false]

        userDefaults.register(defaults: defaultValues)
        
        if userDefaults.bool(forKey: "firstRun") && !userDefaults.bool(forKey: "seeded") {
            seedEmulsions(context: managedObjectContext)
        }
    }
    
    func deleteEmulsion(emulsion: Emulsion) -> Void {
        managedObjectContext.delete(emulsion)
    }

    var body: some View {
        List {
            ForEach(fetchedResults, id: \.self) { result in
                NavigationLink(destination: EmulsionView(emulsion: result, delete: deleteEmulsion)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(result.manufacturer!)
                                .font(.caption)
                                .foregroundColor(Color(.systemGray))
                            Text(result.name!)
                        }
                        .padding([.top, .bottom], 1)
                    }
                }
            }
        }
        .navigationTitle("Film Stocks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showFilmSheet.toggle()
                }) {
                Label("Add film stock", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showFilmSheet, onDismiss: { self.showFilmSheet = false }) {
            AddEmulsionSheet()
        }
        .onAppear {
            seed()
        }
    }
}
