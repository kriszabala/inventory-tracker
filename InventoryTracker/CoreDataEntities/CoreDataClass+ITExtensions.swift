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
import UIKit
import SwiftUI

extension ITBin: Identifiable {	
	static func getSubBinsForBin(bin: ITBin) -> NSFetchRequest<ITBin> {
		let request: NSFetchRequest<ITBin> = ITBin.fetchRequest()
		request.predicate = NSPredicate(format: "parentBin == %@", bin)
		request.sortDescriptors = [NSSortDescriptor(keyPath: \ITBin.name, ascending: true)]
		return request
	}
}

extension ITItem: Identifiable{
	public var photoArray: [UIImage] {
		let set = photos as? Set<ITPhoto> ?? []
		let photoArray = set.sorted {
			$0.wrappedCreateDate < $1.wrappedCreateDate
		}
		var imageArray: [UIImage] = []
		for photo in photoArray{
			imageArray.append(UIImage(data: photo.imageData!)!)
		}
		return imageArray
	}
	
	static func getItemsForBin(bin: ITBin) -> NSFetchRequest<ITItem> {
		let request: NSFetchRequest<ITItem> = ITItem.fetchRequest()
		request.predicate = NSPredicate(format: "bin == %@", bin)
		request.sortDescriptors = [NSSortDescriptor(keyPath: \ITItem.name, ascending: true)]
		return request
	}
	
	public class func testItem (context: NSManagedObjectContext) -> ITItem{
		
		let user = ITUser(context: context)
		
		user.email = "testemail@gmail.com"
		user.firstName = "test"
		user.lastName = "user"
		user.id = UUID()
		user.pwHash = "lkajdfad"
		user.createDate = Date()
		
		let thisItem = ITItem(context: context)
		
		thisItem.id = UUID()
		thisItem.createUser = user
		thisItem.createDate = Date()
		
		thisItem.notes = "Ball Peen Hammer"
		thisItem.name = "Hammer2"
		thisItem.quantity = 1
		thisItem.minLevel = 0
		thisItem.price = 0.00
		
		for index in 0...2{
			let photo = ITPhoto(context: context)
			photo.id = UUID()
			photo.createDate = Date()
			photo.createUser = user
			photo.imageData = UIImage(named: "test\(index)")?.jpegData(compressionQuality: 1)
			photo.item = thisItem
			thisItem.addToPhotos(photo)
		}
		return thisItem
	}
}

extension ITPhoto: Identifiable {
	public var wrappedCreateDate: Date {
		createDate ?? Date()
	}
}

