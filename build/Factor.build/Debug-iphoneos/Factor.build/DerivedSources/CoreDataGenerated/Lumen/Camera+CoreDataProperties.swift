//
//  Camera+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 5/5/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Camera {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Camera> {
        return NSFetchRequest<Camera>(entityName: "Camera")
    }

    @NSManaged public var bulbMode: Bool
    @NSManaged public var digital: Bool
    @NSManaged public var manufacturer: String?
    @NSManaged public var model: String?
    @NSManaged public var notes: String?
    @NSManaged public var note: Note?

}

extension Camera : Identifiable {

}
