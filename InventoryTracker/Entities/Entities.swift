//
//  ITUser.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 6/4/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CoreStore
import Resolver
import UIKit

class Bin: CoreStoreObject {
	@Field.Stored("id")
	var id = UUID()
	
	@Field.Stored("createDate")
	var createDate = Date()
	
	@Field.Stored("level")
	var level: Int16 = 0
	
	@Field.Stored("name")
	var name: String = ""
	
	@Field.Stored("notes")
	var notes: String = ""
	
	@Field.Relationship("createUser")
	var createUser: User?
	
	@Field.Relationship("parentBin")
	var parentBin: Bin?
	
	@Field.Relationship("items", inverse: \.$bin)
	var items: Set<Item>
	
	@Field.Relationship("photos", inverse: \.$bin)
	var photos: Set<Photo>
	
	@Field.Relationship("subBins", inverse: \.$parentBin)
	var subBins: Set<Bin>
	
	@Field.Relationship("tags")
	var tags: Set<Tag>
	
	func displayName() -> String {
		if let parentBin = self.parentBin {
			return "\(parentBin.displayName())\u{2b95}\(self.name)"
		}
		return self.name
	}
}

class Photo: CoreStoreObject {
	@Field.Stored("id")
	var id = UUID()
	
	@Field.Stored("createDate")
	var createDate = Date()
	
	@Field.Stored("imageData")
	var imageData = Data()
	
	@Field.Relationship("createUser")
	var createUser: User?
	
	@Field.Relationship("bin")
	var bin: Bin?
	
	@Field.Relationship("item")
	var item: Item?
}

class Tag: CoreStoreObject {
	@Field.Stored("id")
	var id = UUID()
	
	@Field.Stored("createDate")
	var createDate = Date()
	
	@Field.Stored("name")
	var name: String = ""
	
	@Field.Relationship("createUser")
	var createUser: User?
	
	@Field.Relationship("bins", inverse: \.$tags)
	var bins: Set<Bin>
	
	@Field.Relationship("items", inverse: \.$tags)
	var items: Set<Item>
}
