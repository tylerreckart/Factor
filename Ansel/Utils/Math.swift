//
//  Math.swift
//  Ansel
//
//  Created by Tyler Reckart on 9/3/22.
//

import Foundation

func convertToInt32(_ str: String) throws -> Int32? {
    let asInt = Int32(str)
    
    if asInt != nil {
        return asInt
    } else {
        throw ValidationError.NaN
    }
}

func convertToDouble(_ str: String) throws -> Double? {
    let asDouble = Double(str)
    
    if asDouble != nil {
        return asDouble
    } else {
        throw ValidationError.NaN
    }
}
