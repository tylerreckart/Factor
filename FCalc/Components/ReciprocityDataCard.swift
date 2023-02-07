//
//  ReciprocityDataCard.swift
//  FCalc
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI

struct ReciprocityFactorData: View {
    var result: ReciprocityData

    var body: some View {
        VStack(alignment: .leading, spacing: -1) {
            HStack(spacing: 0) {
                Text("Film Stock")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                    .padding(10)
                    .frame(minWidth: 180)
                    .background(Color(.systemGray6))
                    .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                
                Text(result.selectedOption!.key!)
                    .font(.caption)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(3, corners: [.topLeft, .topRight])
            
            HStack(spacing: 0) {
                Text("Reciprocity Factor")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                    .padding(10)
                    .frame(minWidth: 180)
                    .background(Color(.systemGray6))
                    .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                
                Text(String(result.selectedOption!.value))
                    .font(.caption)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
            .frame(maxWidth: .infinity)
            .border(width: 1, edges: [.top], color: Color(.systemGray4))
            
            HStack(spacing: 0) {
                let shutterSpeed = String(Int(round(result.adjustedShutterSpeed)))

                Text("Adjusted Shutter Speed")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                    .padding(10)
                    .frame(minWidth: 180)
                    .background(Color(.systemGray6))
                    .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                
                Text("\(shutterSpeed) seconds")
                    .font(.caption)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
            .frame(maxWidth: .infinity)
            .border(width: 1, edges: [.top], color: Color(.systemGray4))
            .cornerRadius(3, corners: [.bottomLeft, .bottomRight])
        }
        .padding(1)
        .background(Color(.systemGray4))
        .cornerRadius(4)
    }
}

struct ReciprocityDataCard: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var result: ReciprocityData

    @Binding var isEditing: Bool
    @Binding var selectedResults: Set<ReciprocityData>

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
                    ReciprocityFactorData(result: result)
                        .foregroundColor(.primary)
                }
            }
        } else {
            ReciprocityFactorData(result: result)
        }
    }
}
