//
//  DataCoordinator.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Combine
import CoreStore
import Foundation
import SwiftUI

enum LoginStatus: Int, Codable {
	case none
	case loggedIn
	case invalidCredentials
}

enum SaveStatus {
	case saveSuccess
	case saveFailedAlreadyExists
	case saveFailedMissingData
}

let sqliteFilename = "InventoryTracker.sqlite"

class BaseDataCoordinator {
	@Published var loginStatus: LoginStatus = .none
	@Published var loggedInUser: User? = nil

	@Published var photosToAdd: [UIImage] = []
	@Published var photosPending: [UIImage] = []

	private var disposables: Set<AnyCancellable> = []

	static let dataStack: DataStack = {
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
					"Item": [0xa3eb140428afbd67, 0x34f4f096dd1a658c, 0xcf175e410095be9b, 0x568e2e659304288e],
					"Photo": [0x9a698a1e5913dd2c, 0x54f1e40a0d10b34d, 0x73b9b302bbd1efa6, 0xfafa887dcda81ac2],
					"Tag": [0xcef8b075864ef668, 0x7bc71a99a46b6445, 0x4f5b19bf73a23309, 0xd32ef54c858d70cb],
					"User": [0xa702af552c15fce6, 0x359146052ea76b43, 0xbb74668fb3dfce3c, 0x4c53f8277f09204a],
					"UserLogin": [0x1b5779aae5c64218, 0x799e4db88f46b4a3, 0x72e4ac3e9fd6d8af, 0x3f9fe1394f6546b1]
				]
			)
		)
		try! dataStack.addStorageAndWait(SQLiteStore(fileName: sqliteFilename))
		return dataStack
	}()

	init() {
		CoreStoreDefaults.dataStack = BaseDataCoordinator.dataStack

		// Sets loginStatus to .loggedIn if loggedInUser != nil
		$loggedInUser
			.receive(on: RunLoop.main)
			.map { user in
				guard user != nil else {
					return .none
				}
				return .loggedIn
			}
			.assign(to: \.loginStatus, on: self)
			.store(in: &disposables)
	}
}

protocol DataCoordinator: BaseDataCoordinator {
	func login(email: String, password: String)
	func logout()
	func createUser(email: String, password: String, firstName: String, lastName: String)
	func resetAllData()
	func findUserWith(email: String) -> User?
	func createLoginForUser(user: User)
	func latestUserLogin() -> UserLogin?
	func createOrUpdateItem(item: Item?, name: String, bin: Bin?, quantity: Int32, notes: String?, price: Double, minLevel: Int32) -> SaveStatus
	func createBin(name: String, level: Int16, notes: String?, parentBin: Bin?) -> SaveStatus
	func resetAllPhotos()
	func resetPendingPhotos()
	func mergePendingPhotos()
}

class CoreDataCoordinator: BaseDataCoordinator, DataCoordinator, ObservableObject {
	override init() {
		super.init()
		if let userLogin = latestUserLogin(), let user = userLogin.user {
			loggedInUser = CoreStoreDefaults.dataStack.fetchExisting(user)!
		}
	}

	func findBinWith(name: String, level: Int16) -> Bin? {
		let predicate = NSPredicate(format: "name LIKE[c] %@ AND level == %d", name, level)
		do {
			let bins = try CoreStoreDefaults.dataStack.fetchAll(
				From<Bin>(),
				Where<Bin>(predicate)
			)
			if bins.count > 0 {
				print("Found bin")
				return bins[0]
			}

		} catch {
			fatalError("Failed to fetch ITBin: \(error)")
		}
		return nil
	}

	func createBin(name: String, level: Int16, notes: String?, parentBin: Bin?) -> SaveStatus {
		if findBinWith(name: name, level: level) != nil {
			print("Bin with name \(name) and level \(level) already exists")
			return .saveFailedAlreadyExists
		}
		if let currentUser = loggedInUser {
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

	func createOrUpdateItem(item: Item?, name: String, bin: Bin?, quantity: Int32, notes: String?, price: Double, minLevel: Int32) -> SaveStatus {
		if let currentUser = loggedInUser {
			if item == nil, findItemWith(name: name, bin: bin) != nil {
				print("Item with name \(name) in bin \(String(describing: bin?.name)) already exists")
				return .saveFailedAlreadyExists
			}

			CoreStoreDefaults.dataStack.perform(
				asynchronous: { transaction in
					var thisItem: Item
					let currentUser = transaction.edit(currentUser)!
					if let item = item {
						thisItem = transaction.edit(item)!
					} else {
						thisItem = transaction.create(Into<Item>())
					}
					thisItem.id = UUID()
					thisItem.createUser = currentUser
					currentUser.items.insert(thisItem)
					thisItem.createDate = Date()
					thisItem.name = name
					thisItem.quantity = quantity
					thisItem.minLevel = minLevel
					thisItem.price = price

					if let bin = bin {
						let bin = transaction.edit(bin)!
						thisItem.bin = bin
						bin.items.insert(thisItem)
					}

					if let notes = notes {
						thisItem.notes = notes
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
					// self.resetAllPhotos()
				}
			)
			return .saveSuccess
		}
		print("Item save failed")
		return .saveFailedMissingData
	}

	func resetAllPhotos() {
		photosToAdd.removeAll()
		resetPendingPhotos()
	}

	func resetPendingPhotos() {
		photosPending.removeAll()
	}

	func mergePendingPhotos() {
		photosToAdd += photosPending
		resetPendingPhotos()
	}

	func findItemWith(name: String, bin: Bin?) -> Item? {
		do {
			let results = try CoreStoreDefaults.dataStack.fetchAll(
				From<Item>(),
				Where<Item>(NSPredicate(format: "name LIKE[c] %@", name)) && Where<Item>(\.$bin == bin)
			)
			if let item = results.first {
				print("Found Item")
				return item
			}
		} catch {
			fatalError("Failed to fetch ITItems: \(error)")
		}
		return nil
	}

	func latestUserLogin() -> UserLogin? {
		do {
			let userLogin = try CoreStoreDefaults.dataStack.fetchAll(
				From<UserLogin>()
					.where(\.$logoutDate == nil)
			)
			if let userLogin = userLogin.first {
				return userLogin
			}
		} catch {
			fatalError("Failed to fetch from ITUser: \(error)")
		}
		return nil
	}

	func findUserWith(email: String) -> User? {
		// TODO: Handle email checks with . and + characters
		let predicate = NSPredicate(format: "email == %@", email.lowercased())
		do {
			let user = try CoreStoreDefaults.dataStack.fetchAll(
				From<User>(),
				Where<User>(predicate)
			)
			if let user = user.first {
				print("Found user")
				return user
			}
		} catch {
			fatalError("Failed to fetch from ITUser: \(error)")
		}
		return nil
	}

	func login(email: String, password: String) {
		let user = findUserWith(email: email)
		if let user = user {
			if user.pwHash == User.passwordHashFrom(email: email, password: password) {
				createLoginForUser(user: user)
				return
			}
		}
		loginStatus = .invalidCredentials
	}

	func createLoginForUser(user: User) {
		CoreStoreDefaults.dataStack.perform(
			asynchronous: { transaction -> User in
				let user = transaction.edit(user)!
				let userLogin = transaction.create(Into<UserLogin>())
				userLogin.id = UUID()
				userLogin.loginDate = Date()
				userLogin.user = user
				user.logins.insert(userLogin)
				return user
			},
			completion: { result in
				switch result {
				case .failure(let error):
					print(error)
				case .success(let transactionUser):
					DispatchQueue.main.async {
						let user = CoreStoreDefaults.dataStack.fetchExisting(transactionUser)!
						self.loggedInUser = user
					}
				}
			}
		)
	}

	func logout() {
		if let userLogin = latestUserLogin() {
			CoreStoreDefaults.dataStack.perform(
				asynchronous: { transaction in
					let userLogin = transaction.edit(userLogin)!
					userLogin.logoutDate = Date()
				},
				completion: { result in
					switch result {
					case .failure(let error):
						print(error)
					case .success:
						DispatchQueue.main.async {
							self.loggedInUser = nil
						}
					}
				}
			)
		}
	}

	func createUser(email: String, password: String, firstName: String, lastName: String) {
		CoreStoreDefaults.dataStack.perform(
			asynchronous: { transaction -> User in
				let user = transaction.create(Into<User>())
				user.email = email.lowercased()
				user.firstName = firstName
				user.lastName = lastName
				user.id = UUID()
				user.pwHash = User.passwordHashFrom(email: email, password: password)
				user.createDate = Date()
				return user
			},
			completion: { result in
				switch result {
				case .failure(let error):
					print(error)
				case .success(let transactionUser):
					let user = CoreStoreDefaults.dataStack.fetchExisting(transactionUser)!
					self.createLoginForUser(user: user)
				}
			}
		)
	}

	private func sqliteFilePath() -> String {
		FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(Bundle.main.bundleIdentifier!).appendingPathComponent(sqliteFilename).path
	}

	private func deleteSqliteFile() {
		let filePath = sqliteFilePath()
		print("Local path = \(filePath)")

		do {
			let fileManager = FileManager.default
			// Check if file exists
			if fileManager.fileExists(atPath: filePath) {
				// Delete file
				try fileManager.removeItem(atPath: filePath)
			} else {
				print("File does not exist")
			}
		} catch let error as NSError {
			print("An error took place: \(error)")
		}
	}

	func resetAllData() {
		CoreStoreDefaults.dataStack.unsafeRemoveAllPersistentStoresAndWait()
		deleteSqliteFile()
		exit(0)
	}
}
