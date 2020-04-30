//
//  ITUser+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITUser> {
        return NSFetchRequest<ITUser>(entityName: "ITUser")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var pwHash: String?
    @NSManaged public var bins: NSSet?
    @NSManaged public var logins: NSSet?
    @NSManaged public var items: NSSet?
    @NSManaged public var photos: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for bins
extension ITUser {

    @objc(addBinsObject:)
    @NSManaged public func addToBins(_ value: ITBin)

    @objc(removeBinsObject:)
    @NSManaged public func removeFromBins(_ value: ITBin)

    @objc(addBins:)
    @NSManaged public func addToBins(_ values: NSSet)

    @objc(removeBins:)
    @NSManaged public func removeFromBins(_ values: NSSet)

}

// MARK: Generated accessors for logins
extension ITUser {

    @objc(addLoginsObject:)
    @NSManaged public func addToLogins(_ value: ITUserLogin)

    @objc(removeLoginsObject:)
    @NSManaged public func removeFromLogins(_ value: ITUserLogin)

    @objc(addLogins:)
    @NSManaged public func addToLogins(_ values: NSSet)

    @objc(removeLogins:)
    @NSManaged public func removeFromLogins(_ values: NSSet)

}

// MARK: Generated accessors for items
extension ITUser {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ITItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ITItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension ITUser {

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
extension ITUser {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: ITTag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: ITTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
