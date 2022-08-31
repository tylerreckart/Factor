//
//  Reciprocity.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct Reciprocity: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
      entity: ReciprocityData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \ReciprocityData.timestamp, ascending: true)
      ]
    ) var fetchedResults: FetchedResults<ReciprocityData>

    @State private var shutter_speed: String = ""
    @State private var reciprocity_factor: Double = 1.43
    @State private var adjusted_shutter_speed: Double?
    @State private var selected: Emulsion?
    
    @State private var showingHistorySheet: Bool = false

    var body: some View {
        ScrollView {
            ReciprocityForm(shutter_speed: $shutter_speed, calculate: calculate, selected: $selected)
                .padding([.leading, .trailing, .bottom])
                .background(.background)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])

            if adjusted_shutter_speed ?? 0 > 0 {
                CalculatedResultCard(
                    label: "Adjusted shutter speed",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(adjusted_shutter_speed!))) seconds",
                    background: Color(.systemPurple)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Reciprocity Factor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if fetchedResults.count > 0 {
                HStack {
                    Button(action: {
                        self.showingHistorySheet.toggle()
                    }) {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("History")
                    }
                }
            }
        }
        .sheet(isPresented: $showingHistorySheet) {
            ReciprocityHistorySheet()
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
        let newReciprocityData = ReciprocityData(context: managedObjectContext)

        newReciprocityData.adjustedShutterSpeed = self.adjusted_shutter_speed!
        newReciprocityData.timestamp = Date()
        
        let optionData = ReciprocityOption(context: managedObjectContext)
        optionData.key = selected!.name
        optionData.value = selected!.pFactor
        newReciprocityData.selectedOption = optionData

        saveContext()
    }

    private func calculate() {
        let threshold = selected!.threshold
        let speedInt = Int(shutter_speed)
        
        if threshold < speedInt! {
            adjusted_shutter_speed = pow(
                Double(shutter_speed)!, selected!.pFactor
            )
        } else {
            adjusted_shutter_speed = Double(shutter_speed)
        }
        save()
    }
}

struct Reciprocity_Previews: PreviewProvider {
    static var previews: some View {
        Reciprocity()
    }
}
