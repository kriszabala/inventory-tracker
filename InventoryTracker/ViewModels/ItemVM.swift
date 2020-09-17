//
//  ItemVM.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Combine
import Resolver
import SwiftUI

class ItemVM: ObservableObject {
	var dataCoordinator: DataCoordinator = Resolver.resolve()
	
	var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
	private var shouldDismissView = false {
		didSet {
			viewDismissalModePublisher.send(shouldDismissView)
		}
	}
	
	var item: Item?
	var bin: Bin?
	
	// inputs
	@Published var name: String = "Tools"
	@Published var notes: String = "Heirloom"
	@Published var quantity: Int32 = 1
	@Published var showingItemExists: Bool = false
	@Published var photos: [UIImage] = []
	@Published var photosToAdd: [UIImage] = []
	@Published var editMode: Bool = false
	
	private var disposables: Set<AnyCancellable> = []

	func createItem() {
		let status = dataCoordinator.createOrUpdateItem(item: item, name: name, bin: bin, quantity: quantity, notes: notes, price: 0.0, minLevel: 0)
		if status == .saveSuccess {
			shouldDismissView = true
		}
		else if status == .saveFailedAlreadyExists {
			showingItemExists = true
		}
	}

	init(item: Item?, bin: Bin?) {
		dataCoordinator.$photosToAdd
			.receive(on: RunLoop.main)
			.assign(to: \.photosToAdd, on: self)
			.store(in: &disposables)
		
		if let bin = bin {
			self.bin = bin
		}
		
		guard let item = item else {
			return
		}
		self.item = item
		editMode = true
		name = item.name ?? ""
		notes = item.notes ?? ""
		quantity = item.quantity
		photos = item.photoArray
	}
}
