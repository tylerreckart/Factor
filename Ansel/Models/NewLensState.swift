//
//  NewLensState.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/2/22.
//

import Foundation

struct NewLensState: Identifiable, Equatable {
    static func == (lhs: NewLensState, rhs: NewLensState) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String {
        self.name!
    }
    
    var manufacturer: String?
    var name: String?
    var focalLength: Int32?
    var maximumAperture: Double?
    var notes: String?
}
