//
//  ITItem+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITItem> {
        return NSFetchRequest<ITItem>(entityName: "ITItem")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var createUser: ITUser?
    @NSManaged public var bin: ITBin?
    @NSManaged public var photos: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for photos
extension ITItem {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: ITPhoto)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: ITPhoto)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension ITItem {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: ITTag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: ITTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
