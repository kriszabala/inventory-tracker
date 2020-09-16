//
//  UserLogin.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CoreStore
import Foundation

class UserLogin: CoreStoreObject {
	@Field.Stored("id")
	var id = UUID()

	@Field.Stored("loginDate")
	var loginDate = Date()

	@Field.Stored("logoutDate")
	var logoutDate: Date?

	@Field.Relationship("user")
	var user: User?
}
