//
//  LoginVM.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Combine
import Resolver
import SwiftUI

class LoginVM: ObservableObject {
	@Published var dataCoordinator: DataCoordinator = Resolver.resolve()

	@Published var email = "testuser@gmail.com"
	@Published var password = "123456"
	
	//	Outputs
	@Published var loginMessage = ""
	@Published var isShowingCreateUserView: Bool = false
	
	private var disposables: Set<AnyCancellable> = []
	
	init() {
		dataCoordinator.$loginStatus
			.receive(on: RunLoop.main)
			.map { status in
				switch status {
				case .none:
					return ""
				case .invalidCredentials:
					return "Information not correct. Try again."
				case .loggedIn:
					self.isShowingCreateUserView = false
					return ""
				}
			}
			.assign(to: \.loginMessage, on: self)
			.store(in: &disposables)
	}
	
	func login() {
		dataCoordinator.login(email: email, password: password)
	}
	
	func createUser() {
		isShowingCreateUserView = true
	}
}
