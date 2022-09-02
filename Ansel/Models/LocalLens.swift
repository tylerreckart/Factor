//
//  Lenses.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/2/22.
//

import Foundation

struct LocalLens: Identifiable, Equatable {
    static func == (lhs: LocalLens, rhs: LocalLens) -> Bool {
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
