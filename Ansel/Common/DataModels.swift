//
//  Constants.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

struct ReciprocityDropdownOption: Hashable {
    public static func == (lhs: ReciprocityDropdownOption, rhs: ReciprocityDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var value: Double
}

struct FilterDropdownOption: Hashable {
    public static func == (lhs: FilterDropdownOption, rhs: FilterDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var value: Double
}
