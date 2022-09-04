//
//  CalculationData.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/1/22.
//

import SwiftUI

struct CalculationData: View {
    @Binding var reciprocityData: Set<ReciprocityData>
    @Binding var filterData: Set<FilterData>
    @Binding var bellowsData: Set<BellowsExtensionData>

    var body: some View {
        VStack {
            if reciprocityData.count > 0 {
                VStack(alignment: .leading) {
                    Text("Reciprocity Data")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(.leading, 10)

                    ForEach(Array(reciprocityData), id: \.self) { data in
                        ReciprocityFactorData(result: data)
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
            
            if filterData.count > 0 {
                VStack(alignment: .leading) {
                    Text("Filter Factor Data")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(.leading, 10)

                    ForEach(Array(filterData), id: \.self) { data in
                        FilterFactorData(result: data)
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
            
            if bellowsData.count > 0 {
                VStack(alignment: .leading) {
                    Text("Bellows Extension Data")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                        .padding(.leading, 10)
                    
                    ForEach(Array(bellowsData), id: \.self) { data in
                        BellowsData(result: data)
                            .padding(.bottom, 10)
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
        .padding(.bottom, 20)
    }
}
