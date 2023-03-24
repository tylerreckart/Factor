//
//  DashboardTile.swift
//  Factor
//
//  Created by Tyler Reckart on 9/13/22.
//

import Foundation
import SwiftUI

struct DashboardTile: Identifiable, Equatable {
    static func == (lhs: DashboardTile, rhs: DashboardTile) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String {
        self.key
    }

    var key: String
    var label: String
    var icon: String
    var background: Color
}
