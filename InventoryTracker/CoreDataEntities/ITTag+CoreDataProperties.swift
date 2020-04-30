//
//  ITTag+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITTag> {
        return NSFetchRequest<ITTag>(entityName: "ITTag")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var createDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var createUser: ITUser?
    @NSManaged public var items: NSSet?
    @NSManaged public var bins: NSSet?

}

// MARK: Generated accessors for items
extension ITTag {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ITItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ITItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for bins
extension ITTag {

    @objc(addBinsObject:)
    @NSManaged public func addToBins(_ value: ITBin)

    @objc(removeBinsObject:)
    @NSManaged public func removeFromBins(_ value: ITBin)

    @objc(addBins:)
    @NSManaged public func addToBins(_ values: NSSet)

    @objc(removeBins:)
    @NSManaged public func removeFromBins(_ values: NSSet)

}
