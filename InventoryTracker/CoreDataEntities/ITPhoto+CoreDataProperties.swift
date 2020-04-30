//
//  ITPhoto+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITPhoto> {
        return NSFetchRequest<ITPhoto>(entityName: "ITPhoto")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var createDate: Date?
    @NSManaged public var item: ITItem?
    @NSManaged public var createUser: ITUser?
    @NSManaged public var bin: ITBin?

}
