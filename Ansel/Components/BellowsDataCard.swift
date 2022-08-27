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
                    .background(Color(.systemGray5))
                    .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                
                Text(result.bellowsExtensionFactor!)
                    .font(.caption)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
            .frame(maxWidth: .infinity)
            .border(Color(.systemGray4), width: 1)
            
            if !result.compensatedAperture!.isEmpty {
                HStack(spacing: 0) {
                    Text("Compensated Aperture")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(10)
                        .padding(.trailing, 9)
                        .background(Color(.systemGray5))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                    
                    Text("f/\(result.compensatedAperture!)")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
                .frame(maxWidth: .infinity)
                .border(Color(.systemGray4), width: 1)
            } else {
                HStack(spacing: 0) {
                    Text("Compensated Shutter")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(10)
                        .padding(.trailing, 17)
                        .background(Color(.systemGray5))
                        .border(width: 1, edges: [.trailing], color: Color(.systemGray4))
                    
                    Text("\(result.compensatedShutter!) seconds")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
                .frame(maxWidth: .infinity)
                .border(Color(.systemGray4), width: 1)
            }
            
            HStack(spacing: 0) {
                if !result.aperture!.isEmpty {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Aperture")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(.systemGray5))
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
                            .background(Color(.systemGray5))
                            .border(width: 1, edges: [.bottom], color: Color(.systemGray4))
                        Text("f/\(result.shutterSpeed!)")
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
                        .background(Color(.systemGray5))
                        .border(width: 1, edges: [.bottom], color: Color(.systemGray4))
                    Text("f/\(result.focalLength!)mm")
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
                        .background(Color(.systemGray5))
                        .border(width: 1, edges: [.bottom], color: Color(.systemGray4))
                    Text("f/\(result.bellowsDraw!)mm")
                        .font(.caption)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                }
            }
            .frame(maxWidth: .infinity)
            .border(Color(.systemGray4), width: 1)
        }
    }
}

struct BellowsDataCard: View {
    var result: BellowsExtensionData

    @Binding var isEditing: Bool
    @Binding var selectedResults: [BellowsExtensionData]

    var body: some View {
        if isEditing {
            HStack {
                if !selectedResults.contains(where: { $0.timestamp == result.timestamp }) {
                    Image(systemName: "circle")
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
                
                Button(action: {
                    if !selectedResults.contains(where: { $0.timestamp == result.timestamp }) {
                        selectedResults.append(result)
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
