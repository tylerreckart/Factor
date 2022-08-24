//
//  FilterFactor.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/17/22.
//
import SwiftUI

struct FilterForm: View {
    @Binding var priority_mode: PriorityMode
    @Binding var shutter_speed: String
    @Binding var aperture: String
    @Binding var calculated_factor: Bool

    var calculate: () -> Void
    var reset: () -> Void
    
    var options = [
        FilterDropdownOption(key: "1", value: 1),
        FilterDropdownOption(key: "2", value: 2),
        FilterDropdownOption(key: "3", value: 3),
        FilterDropdownOption(key: "4", value: 4),
        FilterDropdownOption(key: "5", value: 5),
        FilterDropdownOption(key: "6", value: 6),
        FilterDropdownOption(key: "7", value: 7),
        FilterDropdownOption(key: "8", value: 8),
        FilterDropdownOption(key: "9", value: 9),
        FilterDropdownOption(key: "10", value: 10),
    ]
    
    @Binding var selected: FilterDropdownOption
    
    var body: some View {
        VStack {
            PriorityModeToggle(
                priority_mode: $priority_mode,
                aperture: $aperture,
                shutter_speed:$shutter_speed,
                calculated_factor: $calculated_factor,
                reset: self.reset
            )

            Text("Inputs")
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
            
            VStack(spacing: -1) {
                HStack {
                    Text("F-Stop Reduction")
                        .font(.system(.caption))
                        .frame(height: 55, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing])
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray5))
            
                    Picker("Select a filter factor", selection: $selected) {
                        ForEach(options, id: \.self) {
                            Text($0.key)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                }
                .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.topLeft, .topRight])
            
                if self.priority_mode == .aperture {
                    FormInput(
                        text: $shutter_speed,
                        placeholder: "Shutter Speed (seconds)"
                    )
                    .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.bottomLeft, .bottomRight])
                }
                
                if self.priority_mode == .shutter {
                    FormInput(
                        text: $aperture,
                        placeholder: "Aperture"
                    )
                    .addBorder(Color(.systemGray5), width: 1, cornerRadius: 4, corners: [.bottomLeft, .bottomRight])
                }
            }
            
            CalculateButton(calculate: calculate, isDisabled: self.priority_mode == .aperture ? self.shutter_speed.count == 0 : self.aperture.count == 0)
        }
        .padding(.top)
    }
}

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
                FilterCard(
                    label: "Adjusted shutter speed (seconds)",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(Double(compensated_shutter) ?? 1))) seconds",
                    background: Color(.systemPurple)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
            
            if !self.compensated_aperture.isEmpty {
                FilterCard(
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
