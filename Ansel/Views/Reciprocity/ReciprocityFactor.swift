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

    @State private var shutterSpeed: String = ""
    @State private var reciprocity_factor: Double = 1.43
    @State private var adjustedShutterSpeed: Double?
    @State private var selected: Emulsion?
    
    @State private var showingHistorySheet: Bool = false
    
    @State private var presentError: Bool = false

    var body: some View {
        ScrollView {
            ReciprocityForm(
                shutterSpeed: $shutterSpeed,
                calculate: calculate,
                selected: $selected
            )
                .padding([.leading, .trailing, .bottom])
                .background(.background)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])

            if adjustedShutterSpeed ?? 0 > 0 {
                CalculatedResultCard(
                    label: "Adjusted shutter speed",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(adjustedShutterSpeed!))) seconds",
                    background: Color(.systemPurple)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Reciprocity Factor")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $presentError, error: ValidationError.NaN) {_ in
            Button(action: {
                presentError = false
            }) {
                Text("Ok")
            }
        } message: { error in
            Text("Unable to process inputs. Please try again.")
        }
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

        newReciprocityData.adjustedShutterSpeed = self.adjustedShutterSpeed!
        newReciprocityData.timestamp = Date()
        
        let optionData = ReciprocityOption(context: managedObjectContext)
        optionData.key = selected!.name
        optionData.value = selected!.pFactor
        newReciprocityData.selectedOption = optionData

        saveContext()
    }

    private func calculate() -> Void {
        let threshold: Int32? = selected?.threshold ?? nil

        if threshold != nil {
            do {
                let thresholdDouble = try convertToDouble(String(selected!.threshold))!
                let asDouble = try convertToDouble(shutterSpeed)!
                
                if thresholdDouble < asDouble {
                    adjustedShutterSpeed = pow(asDouble, selected!.pFactor)
                } else {
                    adjustedShutterSpeed = Double(shutterSpeed)
                }
                save()
            } catch {
                presentError = true
                return
            }
        } else {
            presentError = true
            return
        }
    }
}
