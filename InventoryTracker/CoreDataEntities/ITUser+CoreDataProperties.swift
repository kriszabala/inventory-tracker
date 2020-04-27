//
//  ITUser+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/26/20.
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
    @NSManaged public var dateCreated: Date?
		@NSManaged public var pwHash: String?
}
	
}
