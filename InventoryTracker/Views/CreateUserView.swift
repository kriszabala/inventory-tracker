//
//  CreateUserView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/26/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct CreateUserView: View {
	@ObservedObject private var createUserVM = CreateUserVM()
	@Environment(\.presentationMode) var presentationMode

	var body: some View {
		KeyboardGuardian {
			ZStack {
				VStack {
					Group {
						TextField("Email Address", text: $createUserVM.email).modifier(ITTextFieldStyle())
						if !createUserVM.emailMessage.isEmpty {
							Text(createUserVM.emailMessage)
								.foregroundColor(.red)
						}
						TextField("First Name", text: $createUserVM.firstName).modifier(ITTextFieldStyle())
						if !createUserVM.firstNameMessage.isEmpty {
							Text(createUserVM.firstNameMessage)
								.foregroundColor(.red)
						}
						TextField("Last Name", text: $createUserVM.lastName).modifier(ITTextFieldStyle())
						if !createUserVM.lastNameMessage.isEmpty {
							Text(createUserVM.lastNameMessage)
								.foregroundColor(.red)
						}
						TextField("Password", text: $createUserVM.password).modifier(ITTextFieldStyle())
						if !createUserVM.passwordMessage.isEmpty {
							Text(createUserVM.passwordMessage)
								.foregroundColor(.red)
						}
					}

					Button(action: {
						self.createUserVM.createUserAction()
					}) {
						ITButton(label: "CREATE USER")
					}.disabled(!self.createUserVM.isValid)

					Button(action: {
						self.presentationMode.wrappedValue.dismiss()
					}) {
						ITButton(label: "CANCEL")
					}
				}
			}
			.padding()
		}
	}
}

#if DEBUG
struct CreateUserView_Previews: PreviewProvider {
	static var previews: some View {
		CreateUserView()
	}
}
#endif

struct ITTextFieldStyle: ViewModifier {
	func body(content: Content) -> some View {
		return content
			.padding()
			.background(Palette.lightGreyColor)
			.cornerRadius(5.0)
			.padding(.top, 10)
	}
}
