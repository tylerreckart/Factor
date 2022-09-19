//
//  FilterDataCard.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct FilterFactorData: View {
    var result: FilterData

    var body: some View {
        VStack(alignment: .leading, spacing: -1) {
            HStack(spacing: 0) {
                Text("F-Stop Reduction")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                    .padding(10)
                    .frame(minWidth: 180)
                    .background(Color(.systemGray6))
                    .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                
                Text("\(Int(result.fStopReduction))")
                    .font(.caption)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(3, corners: [.topLeft, .topRight])
            
            if result.compensatedAperture > 0 {
                HStack(spacing: 0) {
                    Text("Compensated Aperture")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(10)
                        .frame(minWidth: 180)
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                    
                    Text("f/\(Int(result.compensatedAperture))")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
                .frame(maxWidth: .infinity)
                .border(width: 1, edges: [.top], color: Color(.systemGray4))
                
            } else {
                HStack(spacing: 0) {
                    Text("Compensated Shutter")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(10)
                        .frame(minWidth: 180)
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                    
                    Text("\(Int(result.compensatedShutterSpeed)) seconds")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
                .frame(maxWidth: .infinity)
                .border(width: 1, edges: [.top], color: Color(.systemGray4))
                .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
            }
        }
        .padding(1)
        .background(Color(.systemGray4))
        .cornerRadius(4)
    }
}

struct FilterDataCard: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var result: FilterData

    @Binding var isEditing: Bool
    @Binding var selectedResults: Set<FilterData>

    var body: some View {
        if isEditing {
            HStack {
                if !selectedResults.contains(where: { $0.timestamp == result.timestamp }) {
                    Image(systemName: "circle")
                        .foregroundColor(userAccentColor)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(userAccentColor)
                }
                
                Button(action: {
                    if !selectedResults.contains(where: { $0.timestamp == result.timestamp }) {
                        selectedResults.insert(result)
                    } else {
                        selectedResults = selectedResults.filter { $0.timestamp != result.timestamp }
                    }
                }) {
                    FilterFactorData(result: result)
                        .foregroundColor(.primary)
                }
            }
        } else {
            FilterFactorData(result: result)
        }
    }
}
