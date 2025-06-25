//
//  Emulsion+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 5/20/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Emulsion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emulsion> {
        return NSFetchRequest<Emulsion>(entityName: "Emulsion")
    }

    @NSManaged public var iso: Int32
    @NSManaged public var manufacturer: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var pFactor: Double
    @NSManaged public var threshold: Int32
    @NSManaged public var exposures: LoggedExposure?
    @NSManaged public var note: Note?

}

extension Emulsion : Identifiable {

}
