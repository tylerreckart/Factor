//
//  ReciprocityData+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 6/25/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ReciprocityData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReciprocityData> {
        return NSFetchRequest<ReciprocityData>(entityName: "ReciprocityData")
    }

    @NSManaged public var adjustedShutterSpeed: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var note: Note?
    @NSManaged public var selectedOption: ReciprocityOption?

}

extension ReciprocityData : Identifiable {

}
