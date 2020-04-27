//
//  ITBin+CoreDataProperties.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData


extension ITBin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITBin> {
        return NSFetchRequest<ITBin>(entityName: "ITBin")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var createDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var name: String?
    @NSManaged public var level: Int16
    @NSManaged public var createUser: ITUser?
    @NSManaged public var parentBin: ITBin?
    @NSManaged public var subBins: NSSet?

}

// MARK: Generated accessors for subBin
extension ITBin {

    @objc(addSubBinObject:)
    @NSManaged public func addToSubBins(_ value: ITBin)

    @objc(removeSubBinObject:)
    @NSManaged public func removeFromSubBins(_ value: ITBin)

    @objc(addSubBin:)
    @NSManaged public func addToSubBins(_ values: NSSet)

    @objc(removeSubBin:)
    @NSManaged public func removeFromSubBins(_ values: NSSet)

}
