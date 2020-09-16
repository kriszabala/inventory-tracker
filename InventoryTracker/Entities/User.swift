//
//  User.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CoreStore
import Foundation

class User: CoreStoreObject {
	@Field.Stored("id")
	var id = UUID()
	
	@Field.Stored("createDate")
	var createDate = Date()
	
	@Field.Stored("email")
	var email: String = ""
	
	@Field.Stored("firstName")
	var firstName: String = ""
	
	@Field.Stored("lastName")
	var lastName: String = ""
	
	@Field.Stored("pwHash")
	var pwHash: String = ""
	
	@Field.Relationship("bins", inverse: \.$createUser)
	var bins: Set<Bin>
	
	@Field.Relationship("items", inverse: \.$createUser)
	var items: Set<Item>
	
	@Field.Relationship("logins", inverse: \.$user)
	var logins: Set<UserLogin>
	
	@Field.Relationship("photos", inverse: \.$createUser)
	var photos: Set<Photo>
	
	@Field.Relationship("tags", inverse: \.$createUser)
	var tags: Set<Tag>
	
	static func passwordHashFrom(email: String, password: String) -> String {
		return "\(password).\(email.lowercased()).\(Config.pwHashSalt)".sha256()
	}
}
