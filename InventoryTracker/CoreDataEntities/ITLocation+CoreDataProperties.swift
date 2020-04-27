//
//  ITLocation+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITLocation> {
        return NSFetchRequest<ITLocation>(entityName: "ITLocation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var createDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var name: String?
    @NSManaged public var createUser: ITUser?
    @NSManaged public var parentLocation: ITLocation?
    @NSManaged public var subLocations: NSSet?

}

// MARK: Generated accessors for subLocations
extension ITLocation {

    @objc(addSubLocationsObject:)
    @NSManaged public func addToSubLocations(_ value: ITLocation)

    @objc(removeSubLocationsObject:)
    @NSManaged public func removeFromSubLocations(_ value: ITLocation)

    @objc(addSubLocations:)
    @NSManaged public func addToSubLocations(_ values: NSSet)

    @objc(removeSubLocations:)
    @NSManaged public func removeFromSubLocations(_ values: NSSet)

}
