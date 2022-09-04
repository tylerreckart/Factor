//
//  NewNoteState.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/3/22.
//

import Foundation

struct NewNoteState: Identifiable, Equatable {
    static func == (lhs: NewNoteState, rhs: NewNoteState) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String {
        self.body!
    }
    
    var body: String?
    var createdAt: Date?
    var images: Data?
    var camera: [Camera?]
    var lens: [Lens?]
    var emulsion: [Emulsion?]
    var bellowsData: [BellowsExtensionData?]
    var reciprocityData: [ReciprocityData?]
    var filterData: [FilterData?]
}
