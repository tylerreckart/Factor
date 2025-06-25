//
//  BellowsExtensionData+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 5/20/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension BellowsExtensionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BellowsExtensionData> {
        return NSFetchRequest<BellowsExtensionData>(entityName: "BellowsExtensionData")
    }

    @NSManaged public var aperture: String?
    @NSManaged public var bellowsDraw: String?
    @NSManaged public var bellowsExtensionFactor: String?
    @NSManaged public var compensatedAperture: String?
    @NSManaged public var compensatedShutter: String?
    @NSManaged public var focalLength: String?
    @NSManaged public var shutterSpeed: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var note: Note?

}

extension BellowsExtensionData : Identifiable {

}
