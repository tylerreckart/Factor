//
//  FilterDropdownOption.swift
//  Factor
//
//  Created by Tyler Reckart on 9/13/22.
//

import Foundation

struct FilterDropdownOption: Hashable {
    public static func == (lhs: FilterDropdownOption, rhs: FilterDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var value: Double
}
