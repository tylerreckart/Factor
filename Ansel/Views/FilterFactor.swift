//
//  FilterFactor.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/17/22.
//
import SwiftUI

struct FilterFactor: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var priority_mode: PriorityMode = .aperture

    @State private var shutter_speed: String = ""
    @State private var aperture: String = ""
    @State private var filter_factor: Double = 1.43
    @State private var compensated_shutter: String = ""
    @State private var compensated_aperture: String = ""
    @State private var selected: FilterDropdownOption = FilterDropdownOption(key: "1", value: 1)
    @State private var calculated_factor: Bool = false
    
    @State private var showingHistorySheet: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                FilterForm(
                    priority_mode: $priority_mode,
                    shutter_speed: $shutter_speed,
                    aperture: $aperture,
                    calculated_factor: $calculated_factor,
                    calculate: self.calculate,
                    reset: self.reset,
                    selected: $selected
                )
            }
            .padding([.leading, .trailing, .bottom])
            .background(.background)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            .padding([.leading, .trailing, .bottom])

            if !self.compensated_shutter.isEmpty {
                CalculatedResultCard(
                    label: "Adjusted shutter speed (seconds)",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(Double(compensated_shutter) ?? 1))) seconds",
                    background: Color(.systemPurple)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
            
            if !self.compensated_aperture.isEmpty {
                CalculatedResultCard(
                    label: "Adjusted aperture",
                    icon: "f.cursive.circle.fill",
                    result: "f/\(Int(round(Double(compensated_aperture) ?? 1)))",
                    background: Color(.systemGreen)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Filter Factor")
        .navigationBarTitleDisplayMode(.inline)
    }

    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    private func calculate() {
        let reduction = log2(self.selected.value)

        if self.priority_mode == .aperture {
            let reduction = log2(self.selected.value)
            let adjustment = pow(2, reduction)
            let adjusted_speed = Double(self.shutter_speed)! * adjustment

            self.compensated_shutter = "\(Int(adjusted_speed))"
        }
        
        if self.priority_mode == .shutter {
            let adjustment = pow(2, reduction)
            let adjusted_aperture = Double(self.aperture)! * (adjustment / 2)

            self.compensated_aperture = "\(Int(closestValue(f_stops, adjusted_aperture)))"
        }
        
        self.calculated_factor = true
    }
    
    private func reset() {
        self.calculated_factor = false
        self.compensated_aperture = ""
        self.compensated_shutter = ""
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        FilterFactor()
    }
}
