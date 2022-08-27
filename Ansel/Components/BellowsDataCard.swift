//
//  BellowsDataCard.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/26/22.
//

import SwiftUI

struct BellowsData: View {
    var result: BellowsExtensionData

    var body: some View {
        VStack(alignment: .leading, spacing: -1) {
            HStack(spacing: 0) {
                Text("Bellows Extension Factor")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                    .padding(10)
                    .frame(minWidth: 180)
                    .background(Color(.systemGray6))
                    .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                
                Text(result.bellowsExtensionFactor!)
                    .font(.caption)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(3, corners: [.topLeft, .topRight])
            
            if !result.compensatedAperture!.isEmpty {
                HStack(spacing: 0) {
                    Text("Compensated Aperture")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(10)
                        .frame(minWidth: 180)
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                    
                    Text("f/\(result.compensatedAperture!)")
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
                    
                    Text("\(result.compensatedShutter!) seconds")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
                .frame(maxWidth: .infinity)
                .border(width: 1, edges: [.top], color: Color(.systemGray4))
            }
            
            HStack(spacing: 0) {
                if !result.aperture!.isEmpty {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Aperture")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .border(width: 1, edges: [.bottom], color: Color(.systemGray4))
                        Text("f/\(result.aperture!)")
                            .font(.caption)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(.background)
                    }
                } else {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Shutter Speed")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .border(width: 1, edges: [.bottom], color: Color(.systemGray4))
                        Text("\(result.shutterSpeed!) seconds")
                            .font(.caption)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(.background)
                    }
                }
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Focal Length")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.bottom], color: Color(.systemGray4))
                    Text("\(result.focalLength!)mm")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
                .border(width: 1, edges: [.trailing, .leading], color: Color(.systemGray4))
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Bellows Draw")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .border(width: 1, edges: [.bottom], color: Color(.systemGray4))
                    Text("\(result.bellowsDraw!)mm")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
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

struct BellowsDataCard: View {
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor

    var result: BellowsExtensionData

    @Binding var isEditing: Bool
    @Binding var selectedResults: Set<BellowsExtensionData>

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
                    BellowsData(result: result)
                        .foregroundColor(.primary)
                }
            }
        } else {
            BellowsData(result: result)
        }
    }
}
