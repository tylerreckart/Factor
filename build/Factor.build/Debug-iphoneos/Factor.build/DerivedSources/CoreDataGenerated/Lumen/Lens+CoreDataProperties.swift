//
//  Lens+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 6/25/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Lens {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lens> {
        return NSFetchRequest<Lens>(entityName: "Lens")
    }

    @NSManaged public var focalLength: Int32
    @NSManaged public var manufacturer: String?
    @NSManaged public var maximumAperture: Double
    @NSManaged public var notes: String?
    @NSManaged public var note: Note?

}

extension Lens : Identifiable {

}
