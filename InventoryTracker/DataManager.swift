//
//  DataManager.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/26/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CryptoSwift
import KeychainAccess
import SwiftUI
import CoreStore

struct SystemServices: ViewModifier {
	static var dataManager = DataManager()
	
	func body(content: Content) -> some View {
		content
			// services
			.environmentObject(Self.dataManager)
	}
}

class DataManager: ObservableObject{
	let pwHashSalt = "Jg*<B9@UW6Kde+1OxaSxbf3m#&8W-Kf7"
	static let dataStack:DataStack = {
		let dataStack = DataStack(
		CoreStoreSchema(
			modelVersion: "V1",
			entities: [
				Entity<User>("User"),
				Entity<UserLogin>("UserLogin"),
				Entity<Bin>("Bin"),
				Entity<Item>("Item"),
				Entity<Photo>("Photo"),
				Entity<Tag>("Tag")
			],
			versionLock: [
				"Bin": [0x68dce2554d47e072, 0xb00419fa71dab1f0, 0x501dbd126d791d5e, 0xa25710efb0e63280],
				"Item": [0x18ccd9b8dd849e9f, 0x1c7316acb556f29e, 0x93ac28869e04334c, 0xbe4f93f0dc0b9ef5],
				"Photo": [0x9a698a1e5913dd2c, 0x54f1e40a0d10b34d, 0x73b9b302bbd1efa6, 0xfafa887dcda81ac2],
				"Tag": [0xcef8b075864ef668, 0x7bc71a99a46b6445, 0x4f5b19bf73a23309, 0xd32ef54c858d70cb],
				"User": [0xa702af552c15fce6, 0x359146052ea76b43, 0xbb74668fb3dfce3c, 0x4c53f8277f09204a],
				"UserLogin": [0x473c916f9cc1b856, 0xab80ebb459e6bcff, 0xa77cda7c8f8bf9a, 0x4f7d9f7828d3a0be]
			]
		)
	)
		try! dataStack.addStorageAndWait()
		return dataStack
	}()
	
	private let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "com.zabala.inventory")
	init() {
		CoreStoreDefaults.dataStack = DataManager.dataStack
		//reset()
		
		return
		let user = try! CoreStoreDefaults.dataStack.fetchOne(From<User>().where(\.$firstName == "Kris"))!
		print("Succesfully fetched corestore object \(user)")
		print(user.firstName)
		print(user.lastName)
		print (user.logins.shuffled()[0].loginDate)
		print (user.logins.sorted(by: { $0.loginDate > $1.loginDate }))
	}
	
	@Published var _isLoggedIn : Bool = false
	@Published var photosToAdd: [UIImage] = []
	@Published var photosPending: [UIImage] = []
	
	var currentUser: User?
	
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
	
	func reset () {
		self.isLoggedIn = false
		print("Reseting CoreData store")
		exit(0)
	}
	
	func findUserWith(email: String) -> User? {
		// TODO: Handle email checks with . and + characters
		
		let predicate = NSPredicate(format: "email == %@", email.lowercased())
		do {
			let user = try CoreStoreDefaults.dataStack.fetchAll(
				From<User>(),
				Where<User>(predicate)
			)
			if user.count > 0{
				print("Found user")
				return user[0]
			}
			
		} catch {
			fatalError("Failed to fetch ITUser: \(error)")
		}
		return nil
	}
	
	private func loginForUser(user: User) {
		CoreStoreDefaults.dataStack.perform(
			asynchronous: { transaction in
				let user = transaction.edit(user)!
				let userLogin = transaction.create(Into<UserLogin>())
				userLogin.id = UUID()
				userLogin.loginDate = Date()
				userLogin.user = user
				user.logins.insert(userLogin)
		},
			completion: { result in
				
				switch result {
					
				case .failure(let error):
					print(error)
					
				case .success:
					print("Succesfully created corestore loginForUser")}
		}
		)
		self.currentUser = user
		self.isLoggedIn = true
	}
	
	func login(email: String, password: String) -> Bool{
		print ("Logging in with username \(email) and pw: \(password)")
		if let user = findUserWith(email: email){
			if user.pwHash == passwordHashFrom(email: email, password: password){
				if user.logins.count > 0{
					for thisLogin in user.logins{
						print("User \(user.email) previously logged in on \(thisLogin.loginDate)")
					}
				}
				loginForUser(user: user)
				return true
			}
		}
		return false
	}
	
	enum SaveStatus {
		case saveSuccess
		case saveFailedAlreadyExists
		case saveFailedMissingData
	}
	
	func createUser(email: String, firstName: String, lastName: String, password: String) -> SaveStatus{
		//Check to make sure user with email doesn't already exist
		if findUserWith(email: email) != nil{
			return .saveFailedAlreadyExists
		}
		CoreStoreDefaults.dataStack.perform(
			asynchronous: { transaction in
				let user = transaction.create(Into<User>())
				user.email = email.lowercased()
				user.firstName = firstName
				user.lastName = lastName
				user.id = UUID()
				user.pwHash = self.passwordHashFrom(email: email, password: password)
				user.createDate = Date()
		},
			completion: { result in
				switch result {
				case .failure(let error):
					print(error)
				case .success:
					/// Accessing Objects =====
					let user = try! CoreStoreDefaults.dataStack.fetchOne(From<User>().where(\.$email == email))!
					print("Succesfully created corestore object \(user)")
					self.loginForUser(user: user)
					/// =======================
				}
		}
		)
		return .saveSuccess;
	}
	
	func passwordHashFrom(email: String, password: String) -> String {
		return "\(password).\(email.lowercased()).\(pwHashSalt)".sha256()
	}
	
	func findBinWith(name: String, level: Int16) -> Bin? {
		let predicate = NSPredicate(format: "name LIKE[c] %@ AND level == %d", name, level)
		do {
			let bins = try CoreStoreDefaults.dataStack.fetchAll(
				From<Bin>(),
				Where<Bin>(predicate)
			)
			if bins.count > 0{
				print("Found bin")
				return bins[0]
			}
			
		} catch {
			fatalError("Failed to fetch ITBin: \(error)")
		}
		return nil
	}
	
	func createBin(name: String, level:Int16, notes: String?, parentBin: Bin?) -> SaveStatus{
		if findBinWith(name: name, level: level) != nil{
			print("Bin with name \(name) and level \(level) already exists")
			return .saveFailedAlreadyExists
		}
		if let currentUser = currentUser {
			CoreStoreDefaults.dataStack.perform(
				asynchronous: { transaction in
					let currentUser = transaction.edit(currentUser)!
					let bin = transaction.create(Into<Bin>())
					bin.id = UUID()
					bin.createUser = currentUser
					currentUser.bins.insert(bin)
					bin.createDate = Date()
					bin.name = name
					bin.level = level
					if let notes = notes {
						bin.notes = notes
					}
					if let parentBin = parentBin {
						let parentBin = transaction.edit(parentBin)!
						bin.parentBin = parentBin
						parentBin.subBins.insert(bin)
					}
			},
				completion: { result in
					switch result {
					case .failure(let error):
						print(error)
					case .success:
						print("Bin with name \(name) and level \(level) created succesfully")
					}
			}
			)
			return .saveSuccess
		}
		return .saveFailedMissingData
	}
	
	func displayNameForBin(bin: Bin) -> String{
		if let parentBin = bin.parentBin{
			return "\(displayNameForBin(bin: parentBin))\u{2b95}\(bin.name)"
		}
		return bin.name
	}
	
	func findItemWith(name: String, bin: Bin?) -> Item? {
		do {
			let results = try CoreStoreDefaults.dataStack.fetchAll(
				From<Item>(),
				(Where<Item>(NSPredicate(format: "name LIKE[c] %@", name)) && Where<Item>(\.$bin == bin))
			)
			if results.count > 0{
				print("Found Item")
				return results[0]
			}
		} catch {
			fatalError("Failed to fetch ITItems: \(error)")
		}
		return nil
	}
	
	func createOrUpdateItem(item:Item?, name:String, bin:Bin?, quantity:Int32, notes: String?, price: Double, minLevel:Int32, barcode:String?) -> SaveStatus {
			if let currentUser = currentUser {
				if item == nil, findItemWith(name: name, bin: bin) != nil{
					print("Item with name \(name) in bin \(String(describing: bin?.name)) already exists")
					return .saveFailedAlreadyExists
				}
				
				CoreStoreDefaults.dataStack.perform(
					asynchronous: { transaction in
						var thisItem:Item
						let currentUser = transaction.edit(currentUser)!
						if let item = item {
							thisItem = transaction.edit(item)!
						}
						else{
							thisItem = transaction.create(Into<Item>())
						}
						thisItem.id = UUID()
						thisItem.createUser = currentUser
						currentUser.items.insert(thisItem)
						thisItem.createDate = Date()
						thisItem.name = name
						thisItem.quantity = quantity
						thisItem.barcode = barcode
						thisItem.minLevel = minLevel
						thisItem.price = price
						
						if let bin = bin{
							let bin = transaction.edit(bin)!
							thisItem.bin = bin
							bin.items.insert(thisItem)
						}
						
						if let notes = notes{
							thisItem.notes = notes
						}
						
						if let barcode = barcode, !barcode.isEmpty {
							thisItem.barcode = barcode
						}
						
						for image in self.photosToAdd {
							let photo = transaction.create(Into<Photo>())
							photo.id = UUID()
							photo.createDate = Date()
							photo.createUser = currentUser
							photo.imageData = image.jpegData(compressionQuality: 1)!
							photo.item = thisItem
							thisItem.photos.insert(photo)
						}
				},
					completion: { result in
						switch result {
						case .failure(let error):
							print(error)
						case .success:
							print("Item with name \(name) created succesfully")
						}
						self.resetAllPhotos()
				}
				)
				return .saveSuccess
		}
		print("Item save failed")
		return .saveFailedMissingData
	}
	
	func resetAllPhotos() {
		self.photosToAdd.removeAll()
		self.resetPendingPhotos()
	}
	
	func resetPendingPhotos() {
		self.photosPending.removeAll()
	}
	
	func mergePendingPhotos() {
		self.photosToAdd += self.photosPending
		self.resetPendingPhotos()
	}
}
