//
//  LoggedExposure+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 6/25/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension LoggedExposure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedExposure> {
        return NSFetchRequest<LoggedExposure>(entityName: "LoggedExposure")
    }

    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var notes: String?
    @NSManaged public var pushPull: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var emulsion: Emulsion?

}

extension LoggedExposure : Identifiable {

}
