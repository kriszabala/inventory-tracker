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
	let pwHashSalt = "Jg*<B9@UW6Kde+1OxaSxbf3m#&8W-Kf7"

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
		print("Saving Context")
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
			print("Saved Context Successfully")
		}
		else{
			print("Nothing to save")
		}
	}
	
	func findUserWith(email: String) -> ITUser? {
		// TODO: Handle email checks with . and + characters
	
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ITUser")
		fetchRequest.predicate = NSPredicate(format: "email == %@", email.lowercased())
		do {
			let user = try self.persistentContainer.viewContext.fetch(fetchRequest) as! [ITUser]
			if user.count > 0{
				print("Found user")
				return user[0]
			}
		} catch {
			fatalError("Failed to fetch ITUser: \(error)")
		}
		return nil
	}
	
	func login(email: String, password: String) -> Bool{
		print ("Logging in with username \(email) and pw: \(password)")
		if let user = findUserWith(email: email){
			if user.pwHash == passwordHashFrom(email: email, password: password){
				self.isLoggedIn = true
				return true
			}
		}
		return false
	}
	
	enum CreateUserStatus {
		case createUserSuccess
		case createUserFailedAlreadyExists
	}
	
	func createUser(email: String, firstName: String, lastName: String, password: String) -> CreateUserStatus{
		//Check to make sure user with email doesn't already exist
		if findUserWith(email: email) != nil{
			return .createUserFailedAlreadyExists
		}
		
		let newUser = ITUser(context: self.persistentContainer.viewContext)
		newUser.email = email.lowercased()
		newUser.firstName = firstName
		newUser.lastName = lastName
		newUser.id = UUID()
		newUser.pwHash = passwordHashFrom(email: email, password: password)
		newUser.dateCreated = Date()
		saveContext()
		self.isLoggedIn = true
		return .createUserSuccess;
	}
	
	func passwordHashFrom(email: String, password: String) -> String {
		return "\(password).\(email.lowercased()).\(pwHashSalt)".sha256()
	}
	
}
