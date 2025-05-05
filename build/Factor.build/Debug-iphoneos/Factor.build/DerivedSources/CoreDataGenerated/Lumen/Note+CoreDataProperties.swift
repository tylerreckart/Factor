//
//  Note+CoreDataProperties.swift
//  
//
//  Created by Tyler Reckart on 5/5/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var images: Data?
    @NSManaged public var bellowsData: NSSet?
    @NSManaged public var camera: NSSet?
    @NSManaged public var emulsion: NSSet?
    @NSManaged public var filterData: NSSet?
    @NSManaged public var lens: NSSet?
    @NSManaged public var reciprocityData: NSSet?

}

// MARK: Generated accessors for bellowsData
extension Note {

    @objc(addBellowsDataObject:)
    @NSManaged public func addToBellowsData(_ value: BellowsExtensionData)

    @objc(removeBellowsDataObject:)
    @NSManaged public func removeFromBellowsData(_ value: BellowsExtensionData)

    @objc(addBellowsData:)
    @NSManaged public func addToBellowsData(_ values: NSSet)

    @objc(removeBellowsData:)
    @NSManaged public func removeFromBellowsData(_ values: NSSet)

}

// MARK: Generated accessors for camera
extension Note {

    @objc(addCameraObject:)
    @NSManaged public func addToCamera(_ value: Camera)

    @objc(removeCameraObject:)
    @NSManaged public func removeFromCamera(_ value: Camera)

    @objc(addCamera:)
    @NSManaged public func addToCamera(_ values: NSSet)

    @objc(removeCamera:)
    @NSManaged public func removeFromCamera(_ values: NSSet)

}

// MARK: Generated accessors for emulsion
extension Note {

    @objc(addEmulsionObject:)
    @NSManaged public func addToEmulsion(_ value: Emulsion)

    @objc(removeEmulsionObject:)
    @NSManaged public func removeFromEmulsion(_ value: Emulsion)

    @objc(addEmulsion:)
    @NSManaged public func addToEmulsion(_ values: NSSet)

    @objc(removeEmulsion:)
    @NSManaged public func removeFromEmulsion(_ values: NSSet)

}

// MARK: Generated accessors for filterData
extension Note {

    @objc(addFilterDataObject:)
    @NSManaged public func addToFilterData(_ value: FilterData)

    @objc(removeFilterDataObject:)
    @NSManaged public func removeFromFilterData(_ value: FilterData)

    @objc(addFilterData:)
    @NSManaged public func addToFilterData(_ values: NSSet)

    @objc(removeFilterData:)
    @NSManaged public func removeFromFilterData(_ values: NSSet)

}

// MARK: Generated accessors for lens
extension Note {

    @objc(addLensObject:)
    @NSManaged public func addToLens(_ value: Lens)

    @objc(removeLensObject:)
    @NSManaged public func removeFromLens(_ value: Lens)

    @objc(addLens:)
    @NSManaged public func addToLens(_ values: NSSet)

    @objc(removeLens:)
    @NSManaged public func removeFromLens(_ values: NSSet)

}

// MARK: Generated accessors for reciprocityData
extension Note {

    @objc(addReciprocityDataObject:)
    @NSManaged public func addToReciprocityData(_ value: ReciprocityData)

    @objc(removeReciprocityDataObject:)
    @NSManaged public func removeFromReciprocityData(_ value: ReciprocityData)

    @objc(addReciprocityData:)
    @NSManaged public func addToReciprocityData(_ values: NSSet)

    @objc(removeReciprocityData:)
    @NSManaged public func removeFromReciprocityData(_ values: NSSet)

}

extension Note : Identifiable {

}
