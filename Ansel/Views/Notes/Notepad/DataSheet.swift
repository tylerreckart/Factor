//
//  DataSheet.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI

struct DataSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var save: ([ReciprocityData], [FilterData], [BellowsExtensionData]) -> Void

    @FetchRequest(
      entity: ReciprocityData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \ReciprocityData.timestamp, ascending: true)
      ]
    ) var reciprocityData: FetchedResults<ReciprocityData>
    
    @FetchRequest(
      entity: FilterData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \FilterData.timestamp, ascending: true)
      ]
    ) var filterData: FetchedResults<FilterData>
    
    @FetchRequest(
      entity: BellowsExtensionData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \BellowsExtensionData.timestamp, ascending: true)
      ]
    ) var bellowsData: FetchedResults<BellowsExtensionData>
    
    @State private var selectedReciprocityData: [ReciprocityData] = []
    @State private var selectedFilterData: [FilterData] = []
    @State private var selectedBellowsData: [BellowsExtensionData] = []
    
    func saveState() {
        save(selectedReciprocityData, selectedFilterData, selectedBellowsData)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        NavigationView {
            List {
                if reciprocityData.count > 0 {
                    Section(header: Text("Reciprocity Data").textCase(.none).font(.system(size: 12))) {
                        ForEach(reciprocityData, id: \.self) { result in
                            Button(action: {
                                addReciprocityData(data: result)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(formatDate(date: result.timestamp!))
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                HStack {
                                                    Image(systemName: "film")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(userAccentColor)
                                                    Text(result.selectedOption!.key!)
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.primary)
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(12)

                                                HStack {
                                                    Image(systemName: "r.circle")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(userAccentColor)
                                                    Text("\(result.selectedOption!.value.clean)")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.primary)
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(12)
                                            }
                                            
                                            HStack {
                                                Image(systemName: "clock")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(userAccentColor)
                                                Text("\(round(result.adjustedShutterSpeed).clean) seconds")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.primary)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(12)
                                        }
                                    }
                                    .padding([.top, .bottom], 1)
                                    
                                    if selectedReciprocityData.filter({ $0.id == result.id }).first != nil {
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundColor(userAccentColor)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if filterData.count > 0 {
                    Section(header: Text("Filter Factor Data").textCase(.none).font(.system(size: 12))) {
                        ForEach(filterData, id: \.self) { result in
                            Button(action: {
                                addFilterData(data: result)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(formatDate(date: result.timestamp!))
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        
                                        HStack {
                                            HStack {
                                                Image(systemName: "f.cursive.circle")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(userAccentColor)
                                                Text("\(result.fStopReduction.clean) \(result.fStopReduction > 1 ? "stops" : "stop")")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.primary)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(12)
                                            
                                            if result.compensatedAperture > 0 {
                                                HStack {
                                                    Image(systemName: "f.cursive.circle")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(userAccentColor)
                                                    Text("f/\(result.compensatedAperture.clean)")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.primary)
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(12)
                                            }
                                            
                                            if result.compensatedShutterSpeed > 0 {
                                                HStack {
                                                    Image(systemName: "clock")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(userAccentColor)
                                                    Text("\(result.compensatedShutterSpeed.clean) seconds")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.primary)
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(12)
                                            }
                                        }
                                    }
                                    .padding([.top, .bottom], 1)
                                    
                                    if selectedFilterData.filter({ $0.id == result.id }).first != nil {
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundColor(userAccentColor)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if bellowsData.count > 0 {
                    Section(header: Text("Bellows Extension Data").textCase(.none).font(.system(size: 12))) {
                        ForEach(bellowsData, id: \.self) { result in
                            Button(action: {
                                addBellowsData(data: result)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(formatDate(date: result.timestamp!))
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))

                                        HStack {
                                            HStack {
                                                Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(userAccentColor)
                                                Text(result.bellowsExtensionFactor!)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.primary)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(12)
                                            
                                            if result.compensatedAperture!.count > 0 {
                                                HStack {
                                                    Image(systemName: "f.cursive.circle")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(userAccentColor)
                                                    Text("f/\(result.compensatedAperture!)")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.primary)
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(12)
                                            }
                                            
                                            if result.compensatedShutter!.count > 0 {
                                                HStack {
                                                    Image(systemName: "clock")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(userAccentColor)
                                                    Text("\(result.compensatedShutter!) seconds")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.primary)
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(12)
                                            }
                                        }
                                    }
                                    .padding([.top, .bottom], 1)
                                    
                                    if selectedBellowsData.filter({ $0.id == result.id }).first != nil {
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundColor(userAccentColor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                    .foregroundColor(userAccentColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedReciprocityData.count > 0 || selectedFilterData.count > 0 || selectedBellowsData.count > 0 {
                        Button(action: {
                            saveState()
                        }) {
                            Text("Add")
                                .fontWeight(.bold)
                                .foregroundColor(userAccentColor)
                        }
                    } else {
                        Text("Add")
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGray))
                    }
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/y"
        return dateFormatter.string(from: date)
    }
    
    func addReciprocityData(data: ReciprocityData) {
        let match = selectedReciprocityData.filter({ $0.id == data.id }).first
        
        if match == nil {
            selectedReciprocityData.append(data)
        } else {
            selectedReciprocityData = selectedReciprocityData.filter {
                $0.id != data.id
            }
        }
    }
    
    func addFilterData(data: FilterData) {
        let match = selectedFilterData.filter({ $0.id == data.id }).first
        
        if match == nil {
            selectedFilterData.append(data)
        } else {
            selectedFilterData = selectedFilterData.filter {
                $0.id != data.id
            }
        }
    }
    
    func addBellowsData(data: BellowsExtensionData) {
        let match = selectedBellowsData.filter({ $0.id == data.id }).first
        
        if match == nil {
            selectedBellowsData.append(data)
        } else {
            selectedBellowsData = selectedBellowsData.filter {
                $0.id != data.id
            }
        }
    }
}
