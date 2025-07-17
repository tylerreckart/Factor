//
//  ReciprocityOption+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 7/17/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ReciprocityOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReciprocityOption> {
        return NSFetchRequest<ReciprocityOption>(entityName: "ReciprocityOption")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: Double
    @NSManaged public var data: ReciprocityData?

}

extension ReciprocityOption : Identifiable {

}
