//
//  Item.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/17/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CoreStore
import SwiftUI

class Item: CoreStoreObject {
	@Field.Stored("id")
	var id = UUID()
	
	@Field.Stored("createDate")
	var createDate = Date()
	
	@Field.Stored("minLevel")
	var minLevel: Int32?
	
	@Field.Stored("name")
	var name: String?
	
	@Field.Stored("notes")
	var notes: String?
	
	@Field.Stored("qrCode")
	var qrCode: String?
	
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
		let transaction = CoreStoreDefaults.dataStack.beginUnsafe()
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
		
		return try! CoreStoreDefaults.dataStack.fetchOne(From<Item>())!
	}
}
