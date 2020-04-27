//
//  ITUser+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITUser> {
        return NSFetchRequest<ITUser>(entityName: "ITUser")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var email: String?
    @NSManaged public var createDate: Date?
    @NSManaged public var pwHash: String?
    @NSManaged public var logins: NSSet?

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
