//
//  CreateBinVM.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Combine
import Resolver
import SwiftUI

class CreateBinVM: ObservableObject {
	var dataCoordinator: DataCoordinator = Resolver.resolve()
	
	var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
	private var shouldDismissView = false {
		didSet {
			viewDismissalModePublisher.send(shouldDismissView)
		}
	}
	
	var bin: Bin?
	var parentBin: Bin?
	
	// inputs
	@Published var name: String = "Toolbox"
	@Published var notes: String = "Portables"
	@Published var showingBinExists: Bool = false
	@Published var photos: [UIImage] = []
	@Published var photosToAdd: [UIImage] = []
	@Published var editMode: Bool = false
	
	private var disposables: Set<AnyCancellable> = []
	
	func createBin() {
		let level: Int16
		if let parentBin = self.parentBin {
			level = parentBin.level + 1
		}
		else {
			level = 0
		}
		
		let status = dataCoordinator.createBin(name: name, level: level, notes: notes, parentBin: parentBin)
		if status == .saveSuccess {
			shouldDismissView = true
		}
		else if status == .saveFailedAlreadyExists {
			showingBinExists = true
		}
	}
	
	init(bin: Bin?) {
		guard let bin = bin else {
			return
		}
		self.bin = bin
		editMode = true
		name = bin.name
		notes = bin.notes
	}
	
	init(parentBin: Bin?) {
		guard let parentBin = parentBin else {
			return
		}
		self.parentBin = parentBin
	}
}
