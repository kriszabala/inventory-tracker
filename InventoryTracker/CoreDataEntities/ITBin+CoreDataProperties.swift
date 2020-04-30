//
//  ITBin+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITBin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITBin> {
        return NSFetchRequest<ITBin>(entityName: "ITBin")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var level: Int16
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var createUser: ITUser?
    @NSManaged public var parentBin: ITBin?
    @NSManaged public var subBins: NSSet?
    @NSManaged public var items: NSSet?
    @NSManaged public var tags: NSSet?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for subBins
extension ITBin {

    @objc(addSubBinsObject:)
    @NSManaged public func addToSubBins(_ value: ITBin)

    @objc(removeSubBinsObject:)
    @NSManaged public func removeFromSubBins(_ value: ITBin)

    @objc(addSubBins:)
    @NSManaged public func addToSubBins(_ values: NSSet)

    @objc(removeSubBins:)
    @NSManaged public func removeFromSubBins(_ values: NSSet)

}

// MARK: Generated accessors for items
extension ITBin {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ITItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ITItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension ITBin {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: ITTag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: ITTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension ITBin {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: ITPhoto)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: ITPhoto)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
