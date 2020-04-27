//
//  DataManager.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/26/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CoreData
import CryptoSwift
import KeychainAccess
import SwiftUI

struct SystemServices: ViewModifier {
	static var dataManager = DataManager()
	
	func body(content: Content) -> some View {
		content
			// services
			.environmentObject(Self.dataManager)
			.environment(\.managedObjectContext, Self.dataManager.persistentContainer.viewContext )
	}
}

class DataManager: ObservableObject{
	let pwHashSalt = "Jg*<B9@UW6Kde+1OxaSxbf3m#&8W-Kf7"
	
	private let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "com.zabala.inventory")
	init() {
		//reset()
	}
	
	@Published var _isLoggedIn : Bool = false
	var currentUser: ITUser?
	
	var isLoggedIn: Bool {
		get {
			let email = keychain["isLoggedIn"]
			print("Logged in with email \(email ?? "nil")")
			if currentUser == nil {
				if let email = email{
					currentUser = findUserWith(email: email)
				}
			}
			return email != nil
		}
		set {
			if newValue{
				keychain["isLoggedIn"] = currentUser?.email
			}
			else{
				keychain["isLoggedIn"] = nil
				currentUser = nil
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
		self.isLoggedIn = false
		
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
		print("Saving context")
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
			print("Saved context successfully")
		}
		else{
			print("Nothing to save")
		}
	}
	
	func findUserWith(email: String) -> ITUser? {
		// TODO: Handle email checks with . and + characters
		
		let fetchRequest:NSFetchRequest<ITUser> = ITUser.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "email == %@", email.lowercased())
		do {
			let user = try self.persistentContainer.viewContext.fetch(fetchRequest)
			if user.count > 0{
				print("Found user")
				return user[0]
			}
		} catch {
			fatalError("Failed to fetch ITUser: \(error)")
		}
		return nil
	}
	
	private func loginForUser(user: ITUser) {
		user.addToLogins(createLoginForUser(user: user))
		saveContext()
		self.currentUser = user
		self.isLoggedIn = true
	}
	
	func login(email: String, password: String) -> Bool{
		print ("Logging in with username \(email) and pw: \(password)")
		if let user = findUserWith(email: email){
			if user.pwHash == passwordHashFrom(email: email, password: password){
				if let previousLogins = user.logins{
					for case let thisLogin as ITUserLogin in previousLogins{
						if let date = thisLogin.loginDate, let user = thisLogin.user{
							if let thisEmail = user.email {
								print("User \(thisEmail) previously logged in on \(date)")
							}
						}
					}
				}
				loginForUser(user: user)
				return true
			}
		}
		return false
	}
	
	enum CreateStatus {
		case createSuccess
		case createFailedAlreadyExists
	}
	
	func createLoginForUser(user: ITUser) -> ITUserLogin{
		let login = ITUserLogin(context: self.persistentContainer.viewContext)
		login.id = UUID()
		login.loginDate = Date()
		login.user = user
		return login
	}
	
	func createUser(email: String, firstName: String, lastName: String, password: String) -> CreateStatus{
		//Check to make sure user with email doesn't already exist
		if findUserWith(email: email) != nil{
			return .createFailedAlreadyExists
		}
		
		let newUser = ITUser(context: self.persistentContainer.viewContext)
		newUser.email = email.lowercased()
		newUser.firstName = firstName
		newUser.lastName = lastName
		newUser.id = UUID()
		newUser.pwHash = passwordHashFrom(email: email, password: password)
		newUser.createDate = Date()
		loginForUser(user: newUser)
		return .createSuccess;
	}
	
	func passwordHashFrom(email: String, password: String) -> String {
		return "\(password).\(email.lowercased()).\(pwHashSalt)".sha256()
	}
	
	func findBinWith(name: String, level: Int16) -> ITBin? {
		let fetchRequest:NSFetchRequest<ITBin> = ITBin.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name LIKE[c] %@ AND level == %d", name, level)
		do {
			let bins = try self.persistentContainer.viewContext.fetch(fetchRequest)
			if bins.count > 0{
				print("Found bin")
				return bins[0]
			}
		} catch {
			fatalError("Failed to fetch ITBin: \(error)")
		}
		return nil
	}
	
	func createBin(name: String, level:Int16, notes: String?, parentBin: ITBin?) -> CreateStatus{
		if findBinWith(name: name, level: level) != nil{
			print("Bin with name \(name) and level \(level) already exists")
			return .createFailedAlreadyExists
		}
		
		let newBin = ITBin(context: self.persistentContainer.viewContext)
		newBin.id = UUID()
		newBin.createDate = Date()
		newBin.name = name
		newBin.level = level
		if let notes = notes, !notes.isEmpty {
			/* notes is not blank */
			newBin.notes = notes
		}
		if let currentUser = currentUser {
			newBin.createUser = currentUser
			currentUser.addToBins(newBin)
		}
		if let parentBin = parentBin {
			newBin.parentBin = parentBin
			//parentBin.addToSubBins(newBin)
		}
		saveContext()
		print("Bin with name \(name) and level \(level) created succesfully")
		return .createSuccess;
	}
	
}
