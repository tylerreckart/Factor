//
//  ReciprocityHistorySheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct ReciprocityHistorySheet: View {
    @FetchRequest(
      entity: ReciprocityData.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \ReciprocityData.timestamp, ascending: true)
      ]
    ) var results: FetchedResults<ReciprocityData>
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/y hh:mm:ss"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        List {
            ForEach(results, id: \.self) { r in
                Text(formatDate(date: r.timestamp!))
            }
        }
        .listStyle(.insetGrouped)
    }
}
