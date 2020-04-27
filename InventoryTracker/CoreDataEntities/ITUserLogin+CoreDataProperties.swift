//
//  ITUserLogin+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITUserLogin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITUserLogin> {
        return NSFetchRequest<ITUserLogin>(entityName: "ITUserLogin")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var loginDate: Date?
    @NSManaged public var user: ITUser?

}
