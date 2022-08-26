//
//  Reciprocity.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

struct Reciprocity: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var shutter_speed: String = ""
    @State private var reciprocity_factor: Double = 1.43
    @State private var adjusted_shutter_speed: String = ""
    @State private var selected: ReciprocityDropdownOption = ReciprocityDropdownOption(key: "SFX (>1 Second)", value: 1.43)
    
    @State private var showingHistorySheet: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                ReciprocityForm(
                    shutter_speed: $shutter_speed,
                    calculate: self.calculate,
                    selected: $selected
                )
            }
            .padding([.leading, .trailing, .bottom])
            .background(.background)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            .padding([.leading, .trailing, .bottom])

            if !self.adjusted_shutter_speed.isEmpty {
                CalculatedResultCard(
                    label: "Adjusted shutter speed",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(Double(adjusted_shutter_speed) ?? 1))) seconds",
                    background: Color(.systemPurple)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Reciprocity Factor")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            HStack {
                Button(action: {
                    self.showingHistorySheet.toggle()
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
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

        newReciprocityData.adjustedShutterSpeed = self.adjusted_shutter_speed
        newReciprocityData.timestamp = Date()
        
        let optionData = ReciprocityOption(context: managedObjectContext)
        optionData.key = self.selected.key
        optionData.value = self.reciprocity_factor
        newReciprocityData.selectedOption = optionData

      saveContext()
    }

    private func calculate() {
        self.adjusted_shutter_speed = "\(pow(Double(self.shutter_speed) ?? 1.0, self.selected.value))"
        save()
    }
}

struct Reciprocity_Previews: PreviewProvider {
    static var previews: some View {
        Reciprocity()
    }
}
