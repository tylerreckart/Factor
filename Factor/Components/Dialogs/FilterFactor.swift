//
//  FilterFactor.swift
//  Factor
//
//  Created by Tyler Reckart on 8/17/22.
//
import SwiftUI

struct FilterFactor: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var open: Bool
    
    @State private var priorityMode: PriorityMode = .aperture

    @State private var shutterSpeed: String = ""
    @State private var aperture: String = ""
    @State private var fStopReduction: Double = 1
    @State private var compensatedShutter: Double = 0
    @State private var compensatedAperture: Double = 0
    @State private var selected: Double = 1
    @State private var calculatedFactor: Bool = false
    @State private var showingHistorySheet: Bool = false
    
    @State private var presentError: Bool = false

    var body: some View {
        Dialog(content: {
            VStack {
                VStack {
                    FilterForm(
                        priorityMode: $priorityMode,
                        shutterSpeed: $shutterSpeed,
                        aperture: $aperture,
                        calculatedFactor: $calculatedFactor,
                        calculate: calculate,
                        reset: reset,
                        selected: $selected
                    )
                    .padding()
                }
                
                if compensatedShutter > 0 {
                    CalculatedResultCard(
                        label: "Adjusted shutter speed (seconds)",
                        icon: "clock.circle.fill",
                        result: "\(compensatedShutter.clean) seconds",
                        background: Color(.systemPurple)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                    .padding([.leading, .trailing, .bottom])
                }
                
                if compensatedAperture > 0 {
                    CalculatedResultCard(
                        label: "Adjusted aperture",
                        icon: "f.cursive.circle.fill",
                        result: "f/\(compensatedAperture.clean)",
                        background: Color(.systemGreen)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                    .padding([.leading, .trailing, .bottom])
                }
            }
            .alert(isPresented: $presentError, error: ValidationError.NaN) {_ in
                Button(action: {
                    presentError = false
                }) {
                    Text("Ok")
                }
            } message: { error in
                Text("Unable to process inputs. Please try again.")
            }
        }, open: $open)
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    private func calculate() {
        let adjustment = pow(2, selected)

        do {
            if priorityMode == .aperture {
                let asDouble = try convertToDouble(shutterSpeed)!
                let adjusted_speed = asDouble * adjustment
                
                compensatedShutter = adjusted_speed
            }
            
            if priorityMode == .shutter {
                let asDouble = try convertToDouble(aperture)!
                let adjusted_aperture = asDouble * adjustment
                
                compensatedAperture = closestValue(f_stops, adjusted_aperture)
            }
            
            calculatedFactor = true
            
            save()
        } catch {
            presentError = true
        }
    }

    func save() {
        let filterData = FilterData(context: managedObjectContext)

        filterData.fStopReduction = selected
        filterData.compensatedAperture = compensatedAperture
        filterData.compensatedShutterSpeed = compensatedShutter
        filterData.timestamp = Date()

        saveContext()
    }
    
    private func reset() {
        calculatedFactor = false
        compensatedAperture = 0
        compensatedShutter = 0
    }
}
