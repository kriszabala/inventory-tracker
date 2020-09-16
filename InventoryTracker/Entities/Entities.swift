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
}

class Item: CoreStoreObject {
	@Field.Stored("id")
	var id = UUID()
	
	@Field.Stored("createDate")
	var createDate = Date()
	
	@Field.Stored("minLevel")
	var minLevel: Int32?
	
	@Field.Stored("barcode")
	var barcode: String?
	
	@Field.Stored("name")
	var name: String?
	
	@Field.Stored("notes")
	var notes: String?
	
	@Field.Stored("price")
	var price: Double?
	
	@Field.Stored("quantity")
	var quantity: Int32 = 0
	
	@Field.Relationship("createUser")
	var createUser: User?
	
	@Field.Relationship("bin")
	var bin: Bin?
	
	@Field.Relationship("photos", inverse: \.$item)
	var photos: Set<Photo>
	
	@Field.Relationship("tags")
	var tags: Set<Tag>
	
	public var photoArray: [UIImage] {
		let photoArray = photos.sorted {
			$0.createDate < $1.createDate
		}
		var imageArray: [UIImage] = []
		for photo in photoArray {
			imageArray.append(UIImage(data: photo.imageData)!)
		}
		return imageArray
	}
	
	public var previewPhoto: UIImage {
		let photoArray = photos.sorted {
			$0.createDate < $1.createDate
		}
		
		if photoArray.count > 0 {
			return UIImage(data: photoArray.first!.imageData)!
		}
		return UIImage()
	}
	
	public class func testItem() -> Item {
		let transaction = BaseDataCoordinator.dataStack.beginUnsafe()
		let user = transaction.create(Into<User>())
		user.email = "testemail@gmail.com"
		user.firstName = "test"
		user.lastName = "user"
		user.id = UUID()
		user.pwHash = "lkajdfad"
		user.createDate = Date()
		
		let thisItem = transaction.create(Into<Item>())
		
		thisItem.id = UUID()
		thisItem.createUser = user
		thisItem.createDate = Date()
		
		thisItem.notes = "Ball Peen Hammer"
		thisItem.name = "Hammer"
		thisItem.quantity = 1
		thisItem.minLevel = 0
		thisItem.price = 0.00
		
		for index in 0 ... 2 {
			let photo = transaction.create(Into<Photo>())
			photo.id = UUID()
			photo.createDate = Date()
			photo.createUser = user
			let image = UIImage(named: "test\(index)")!
			let data = image.jpegData(compressionQuality: 1)!
			photo.imageData = data
			photo.item = thisItem
			thisItem.photos.insert(photo)
		}
		transaction.commit { (_) -> Void in }
		
		return try! BaseDataCoordinator.dataStack.fetchOne(From<Item>())!
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
