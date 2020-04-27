//
//  ITBin+CoreDataClass.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
//

import Foundation
import CoreData

extension ITBin: Identifiable {
	static func getBinsForLevel(level: Int16) -> NSFetchRequest<ITBin> {
		let request: NSFetchRequest<ITBin> = ITBin.fetchRequest()
		request.predicate = NSPredicate(format: "level == %d", level)
		request.sortDescriptors = [NSSortDescriptor(keyPath: \ITBin.name, ascending: true)]
		return request
	}
}

