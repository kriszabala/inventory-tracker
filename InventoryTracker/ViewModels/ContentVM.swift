//
//  ContentVM.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Combine
import Foundation
import Resolver

class ContentVM: ObservableObject {
	@Published var dataCoordinator: DataCoordinator = Resolver.resolve()
	@Published var isLoginPresented = false

	private var cancellables = Set<AnyCancellable>()

	init() {
		dataCoordinator.$loginStatus
			.receive(on: RunLoop.main)
			.map { status in
				if status == .loggedIn {
					// Should not show login screen
					return false
				}
				// Should show login screen
				return true
			}
			.assign(to: \.isLoginPresented, on: self)
			.store(in: &cancellables)
	}

	func logout() {
		dataCoordinator.logout()
	}
}
