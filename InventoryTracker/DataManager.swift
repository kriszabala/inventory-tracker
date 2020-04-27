//
//  DataManager.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/26/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Foundation
import CoreData
import CryptoSwift
import KeychainAccess

class DataManager: ObservableObject{
	private let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "com.zabala.inventory")
	init() {
		//reset()
	}
	
	@Published var _isLoggedIn : Bool = false
	var isLoggedIn: Bool {
		get {
			let loggedIn = keychain["isLoggedIn"]
			return loggedIn == "loggedIn"
		}
		set {
			if newValue{
				keychain["isLoggedIn"] = "loggedIn"
			}
			else{
				keychain["isLoggedIn"] = "notLoggedIn"
			}
			self._isLoggedIn = newValue
		}
	}
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "InventoryTracker")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	func reset () {
		print("Reseting CoreData store")
		for persistentStoreDescription in persistentContainer.persistentStoreDescriptions {
			if let storeURL = persistentStoreDescription.url {
				do {
					print("Deleting existing store at URL \(storeURL)", storeURL)
					try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
				} catch {
						fatalError("Error deleting persistent store \(error)")
				}
				
				do {
					print("Creating new store")
					try persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
																																								configurationName: nil,
																																								at: storeURL,
																																								options: nil)
				} catch {
					print(error.localizedDescription)
					fatalError("Unable to Load Persistent Store \(error)")
				}
			}
		}
	}
	
	func saveContext () {
		let context = self.persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	func login(email: String, password: String) -> Bool{
		let emailLowercased = email.lowercased()
		print ("Logging in with username \(emailLowercased) and pw: \(password)")
		let moc = self.persistentContainer.viewContext
		let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ITUser")
		let pwHash = passwordHashFrom(email: emailLowercased, password: password)
		userFetch.predicate = NSPredicate(format: "email == %@ AND pwHash == %@", emailLowercased, pwHash)
		do {
			let user = try moc.fetch(userFetch) as! [ITUser]
			if user.count > 0{
				print("Found user")
				self.isLoggedIn = true
				return true
			}
		} catch {
			fatalError("Failed to fetch ITUser: \(error)")
		}

		return false
	}
	
	func createUser(email: String, firstName: String, lastName: String, password: String) -> Bool{
		let newUser = ITUser(context: self.persistentContainer.viewContext)
		newUser.email = email.lowercased()
		newUser.firstName = firstName
		newUser.lastName = lastName
		newUser.id = UUID()
		newUser.pwHash = passwordHashFrom(email: email, password: password)
		newUser.dateCreated = Date()
		saveContext()
		self.isLoggedIn = true
		return true;
	}
	
	func passwordHashFrom(email: String, password: String) -> String {
		let salt = "Jg*<B9@UW6Kde+1OxaSxbf3m#&8W-Kf7"
		return "\(password).\(email).\(salt)".sha256()
	}
	
}
