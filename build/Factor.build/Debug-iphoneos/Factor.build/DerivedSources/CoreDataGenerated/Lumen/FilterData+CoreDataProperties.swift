//
//  FilterData+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 5/5/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FilterData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilterData> {
        return NSFetchRequest<FilterData>(entityName: "FilterData")
    }

    @NSManaged public var compensatedAperture: Double
    @NSManaged public var compensatedShutterSpeed: Double
    @NSManaged public var fStopReduction: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var note: Note?

}

extension FilterData : Identifiable {

}
