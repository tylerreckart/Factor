//
//  ReciprocityDropdownOption.swift
//  FCalc
//
//  Created by Tyler Reckart on 9/13/22.
//

import Foundation

struct ReciprocityDropdownOption: Hashable {
    public static func == (lhs: ReciprocityDropdownOption, rhs: ReciprocityDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var value: Double
}
