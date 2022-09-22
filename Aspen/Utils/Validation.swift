//
//  Validation.swift
//  Aspen
//
//  Created by Tyler Reckart on 9/3/22.
//

import Foundation

enum ValidationError: LocalizedError {
    case NaN

    var errorDescription: String? {
        switch self {
        case .NaN:
            return "Error"
        }
    }
}
