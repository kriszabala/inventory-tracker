//
//  CreateUserVM.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Combine
import Foundation
import Resolver

class CreateUserVM: ObservableObject {
	@Published var dataCoordinator: DataCoordinator = Resolver.resolve()
	
	// inputs
	@Published var email = "testuser@gmail.com"
	@Published var firstName = "john"
	@Published var lastName = "doe"
	@Published var password = "123456"
	
	// outputs
	@Published var emailMessage = ""
	@Published var passwordMessage = ""
	@Published var firstNameMessage = ""
	@Published var lastNameMessage = ""
	@Published var isValid = false
	
	private var cancellableSet: Set<AnyCancellable> = []
	
	private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
		$email
			.debounce(for: 1.0, scheduler: RunLoop.main)
			.removeDuplicates()
			.map { input in
				input.isValidEmailAddress()
			}
			.eraseToAnyPublisher()
	}
	
	enum PasswordCheck {
		case valid
		case empty
		case notStrongEnough
	}
	
	private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
		$password
			.debounce(for: 0.8, scheduler: RunLoop.main)
			.removeDuplicates()
			.map { password in
				password == ""
			}
			.eraseToAnyPublisher()
	}
	
	private var passwordStrengthPublisher: AnyPublisher<Bool, Never> {
		$password
			.debounce(for: 0.2, scheduler: RunLoop.main)
			.removeDuplicates()
			.map { _ in
				true
			}
			.eraseToAnyPublisher()
	}
	
	private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
		passwordStrengthPublisher
			.map { input in
				// print(Navajo.localizedString(forStrength: strength))
				if input {
					return true
				}
				else {
					return false
				}
			}
			.eraseToAnyPublisher()
	}
	
	private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
		Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordStrongEnoughPublisher)
			.map { passwordIsEmpty, passwordIsStrongEnough in
				if passwordIsEmpty {
					return .empty
				}
				else if !passwordIsStrongEnough {
					return .notStrongEnough
				}
				else {
					return .valid
				}
			}
			.eraseToAnyPublisher()
	}
	
	private var isFormValidPublisher: AnyPublisher<Bool, Never> {
		Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher)
			.map { emailIsValid, passwordIsValid in
				emailIsValid && (passwordIsValid == .valid)
			}
			.eraseToAnyPublisher()
	}
	
	init() {
		isEmailValidPublisher
			.receive(on: RunLoop.main)
			.map { valid in
				valid ? "" : "Please enter a valid email"
			}
			.assign(to: \.emailMessage, on: self)
			.store(in: &cancellableSet)
		
		isPasswordValidPublisher
			.receive(on: RunLoop.main)
			.map { passwordCheck in
				switch passwordCheck {
				case .empty:
					return "Password must not be empty"
				case .notStrongEnough:
					return "Password not strong enough"
				default:
					return ""
				}
			}
			.assign(to: \.passwordMessage, on: self)
			.store(in: &cancellableSet)
		
		isFormValidPublisher
			.receive(on: RunLoop.main)
			.assign(to: \.isValid, on: self)
			.store(in: &cancellableSet)
	}
	
	func createUserAction() {
		// Check if email already exists.
		let user = dataCoordinator.findUserWith(email: email)
		if user != nil {
			emailMessage = "Email already exists."
			isValid = false
		}
		else {
			dataCoordinator.createUser(email: email, password: password, firstName: firstName, lastName: lastName)
		}
	}
}
