//
//  CalculationData.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI

struct NotepadDataCard: View {
    @AppStorage("overrideDefaultUIColors") var overrideDefaultColors: Bool = false

    var icon: String
    var label: String
    var result: String
    var foreground: Color = .white
    var background: Color

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .imageScale(.large)
                    .padding(.bottom, 1)
                Text(label)
                    .font(.system(.caption))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Spacer()
                Text(result)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(.caption))
            }
            .foregroundColor(foreground)
            .padding()
            .background(overrideDefaultColors ? .accentColor : background)
            .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
            .cornerRadius(8)
        }
    }
}

struct ReciprocityDataStack: View {
    var result: ReciprocityData

    var body: some View {
        VStack {
            NotepadDataCard(
                icon: "moon.stars.circle.fill",
                label: "Recirprocity Factor",
                result: String(result.selectedOption!.value),
                background: Color(.systemBlue)
            )
            NotepadDataCard(
                icon: "clock.circle.fill",
                label: "Shutter Speed",
                result: "\(Int(round(result.adjustedShutterSpeed))) seconds",
                background: Color(.systemPurple)
            )
        }
    }
}

struct FilterDataStack: View {
    var result: FilterData

    var body: some View {
        VStack {
            NotepadDataCard(
                icon: "cloud.circle.fill",
                label: "Filter Factor",
                result: String(result.fStopReduction.clean),
                background: Color(.systemBlue)
            )
            if result.compensatedShutterSpeed > 0 {
                NotepadDataCard(
                    icon: "clock.circle.fill",
                    label: "Shutter Speed",
                    result: "\(result.compensatedShutterSpeed.clean) seconds",
                    background: Color(.systemPurple)
                )
            } else {
                NotepadDataCard(
                    icon: "f.cursive.circle.fill",
                    label: "Aperture",
                    result: "f/\(result.compensatedAperture.clean)",
                    background: Color(.systemGreen)
                )
            }
        }
    }
}

struct BellowsDataStack: View {
    var result: BellowsExtensionData

    var body: some View {
        VStack {
            NotepadDataCard(
                icon: "arrow.up.left.and.arrow.down.right.circle.fill",
                label: "Bellows Extension Factor",
                result: result.bellowsExtensionFactor!,
                background: Color(.systemBlue)
            )
            if result.compensatedShutter!.count > 0 {
                NotepadDataCard(
                    icon: "clock.circle.fill",
                    label: "Shutter Speed",
                    result: "\(result.compensatedShutter!) seconds",
                    background: Color(.systemPurple)
                )
            } else {
                NotepadDataCard(
                    icon: "f.cursive.circle.fill",
                    label: "Aperture",
                    result: "f/\(result.compensatedAperture!)",
                    background: Color(.systemGreen)
                )
            }
        }
    }
}

struct CalculationData: View {
    @Binding var reciprocityData: Set<ReciprocityData>
    @Binding var filterData: Set<FilterData>
    @Binding var bellowsData: Set<BellowsExtensionData>

    @Binding var isEditing: Bool

    @State var reciprocityResultsToRemove: Set<ReciprocityData> = []
    @State var filterResultsToRemove: Set<FilterData> = []
    @State var bellowsResultsToRemove: Set<BellowsExtensionData> = []

    var body: some View {
        VStack(alignment: .leading) {
            if reciprocityData.count > 0 {
                Text("Reciprocity")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.systemGray))
                    .padding([.leading, .trailing])
                VStack(alignment: .leading) {
                    ForEach(Array(reciprocityData), id: \.self) { data in
                        if isEditing {
                            HStack(alignment: .center) {
                                if !reciprocityResultsToRemove.contains(where: { $0.timestamp == data.timestamp }) {
                                    Image(systemName: "circle")
                                        .foregroundColor(.accentColor)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                }

                                Button(action: {
                                    if !reciprocityResultsToRemove.contains(where: { $0.timestamp == data.timestamp }) {
                                        reciprocityResultsToRemove.insert(data)
                                    } else {
                                        reciprocityResultsToRemove.remove(data)
                                    }
                                }) {
                                    ReciprocityDataStack(result: data)
                                }
                            }
                        } else {
                            ReciprocityDataStack(result: data)
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            
            if filterData.count > 0 {
                Text("Filters")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.systemGray))
                    .padding([.leading, .trailing])
                VStack(alignment: .leading) {
                    ForEach(Array(filterData), id: \.self) { data in
                        if isEditing {
                            HStack(alignment: .center) {
                                if !filterResultsToRemove.contains(where: { $0.timestamp == data.timestamp }) {
                                    Image(systemName: "circle")
                                        .foregroundColor(.accentColor)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                }

                                Button(action: {
                                    if !filterResultsToRemove.contains(where: { $0.timestamp == data.timestamp }) {
                                        filterResultsToRemove.insert(data)
                                    } else {
                                        filterResultsToRemove.remove(data)
                                    }
                                }) {
                                    FilterDataStack(result: data)
                                }
                            }
                        } else {
                            FilterDataStack(result: data)
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            
            if bellowsData.count > 0 {
                Text("Bellows Extension")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.systemGray))
                    .padding([.leading, .trailing])
                    .padding(.bottom, 1)
                VStack(alignment: .leading) {
                    ForEach(Array(bellowsData), id: \.self) { data in
                        BellowsDataStack(result: data)
                    }
                }
                .padding([.leading, .trailing])
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
}
