//
//  BellowsExtensionHistorySheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct BellowsExtensionHistorySheet: View {
    @FetchRequest(
      entity: BellowsExtensionData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \BellowsExtensionData.timestamp, ascending: true)
      ]
    ) var results: FetchedResults<BellowsExtensionData>
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/y, h:mm a"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        ScrollView {
            Text("Calculation History")
                .font(.system(size: 16, weight: .bold))

            ForEach(results, id: \.self) { r in
                VStack(alignment: .leading) {
                    Text(formatDate(date: r.timestamp!))
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 4)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName:  "arrow.up.left.and.arrow.down.right.circle.fill")
                                .font(.caption)
                                .padding(5)
                                .foregroundColor(.white)
                                .background(Color(.systemBlue))
                                .cornerRadius(.infinity)
                            Text("Extension Factor")
                                .font(.caption)
                                .foregroundColor(Color(.systemGray))
                            Text(r.bellowsExtensionFactor!)
                                .font(.caption)
                                .padding(.trailing, 4)
                        }
                        
                        if r.compensatedAperture != nil && r.compensatedAperture!.count > 0 {
                            HStack {
                                Image(systemName:  "f.cursive.circle.fill")
                                    .font(.caption)
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .background(Color(.systemGreen))
                                    .cornerRadius(.infinity)
                                Text("Compensated Aperture")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                                Text("f/\(r.compensatedAperture!)")
                                    .font(.caption)
                                    .padding(.trailing, 4)
                            }
                        } else {
                            HStack {
                                Image(systemName: "clock.circle.fill")
                                    .font(.caption)
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .background(Color(.systemPurple))
                                    .cornerRadius(.infinity)
                                Text("Compensated Shutter Speed")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                                Text("\(r.compensatedShutter!) seconds")
                                    .font(.caption)
                                    .padding(.trailing, 6)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        if r.aperture != nil && r.aperture!.count > 0 {
                            VStack(alignment: .center) {
                                Text("Aperture")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                                    .padding(.bottom, 1)
                                Text(r.aperture!)
                                    .font(.caption)
                            }
                        } else {
                            VStack(alignment: .center) {
                                Text("Shutter Speed")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                                    .padding(.bottom, 1)
                                Text("\(r.shutterSpeed!) seconds")
                                    .font(.caption)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("Focal Length")
                                .font(.caption)
                                .foregroundColor(Color(.systemGray))
                                .padding(.bottom, 1)
                            Text("\(r.focalLength!)mm")
                                .font(.caption)
                        }
                        
                        Spacer()

                        VStack(alignment: .center) {
                            Text("Bellows Draw")
                                .font(.caption)
                                .foregroundColor(Color(.systemGray))
                                .padding(.bottom, 1)
                            Text("\(r.bellowsDraw!)mm")
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(9)
                }
                .padding()
                .background(.white)
                .cornerRadius(18)
            }
        }
        .padding([.top, .leading, .trailing])
        .background(Color(.systemGray6))
    }
}
