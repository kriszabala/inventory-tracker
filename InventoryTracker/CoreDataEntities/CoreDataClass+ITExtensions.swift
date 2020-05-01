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
	static func getSubBinsForBin(bin: ITBin) -> NSFetchRequest<ITBin> {
		let request: NSFetchRequest<ITBin> = ITBin.fetchRequest()
		request.predicate = NSPredicate(format: "parentBin == %@", bin)
		request.sortDescriptors = [NSSortDescriptor(keyPath: \ITBin.name, ascending: true)]
		return request
	}
}

extension ITItem: Identifiable{
	static func getItemsForBin(bin: ITBin) -> NSFetchRequest<ITItem> {
		let request: NSFetchRequest<ITItem> = ITItem.fetchRequest()
		request.predicate = NSPredicate(format: "bin == %@", bin)
		request.sortDescriptors = [NSSortDescriptor(keyPath: \ITItem.name, ascending: true)]
		return request
	}
}

