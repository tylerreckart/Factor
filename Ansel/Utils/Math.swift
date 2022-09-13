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

func toNearestTen(_ value: Int) -> Float {
    return round(Float(value) / 10) * 10
}

func absoluteValue(_ a: Double, _ b: Double) -> Double {
    if a > b {
        return a - b
    }
    
    return b - a
}

func closestValue(_ arr: [Double], _ el: Double) -> Double {
    var difference: Double = absoluteValue(arr[0], el)
    var result: Double = arr[0];
    var i: Int = 1
    
    while i < arr.count {
        if difference > absoluteValue(arr[i], el) {
            difference = absoluteValue(arr[i], el)
            result = arr[i]
        }
        i += 1
    }
    
    return result
}
