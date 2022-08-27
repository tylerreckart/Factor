//
//  Constants.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI

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

struct DashboardTile: Identifiable, Equatable {
    static func ==(lhs: DashboardTile, rhs: DashboardTile) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String {
        self.key
    }

    var key: String
    var label: String
    var icon: String
    var background: Color
    var destination: AnyView
    
    static func archive(w:DashboardTile) -> Data {
        var fw = w
        return Data(bytes: &fw, count: MemoryLayout<DashboardTile>.stride)
    }

    static func unarchive(d:Data) -> DashboardTile {
        guard d.count == MemoryLayout<DashboardTile>.stride else {
            fatalError("BOOM!")
        }

        var w:DashboardTile?
        d.withUnsafeBytes({(bytes: UnsafePointer<DashboardTile>)->Void in
            w = UnsafePointer<DashboardTile>(bytes).pointee
        })
        return w!
    }
}
