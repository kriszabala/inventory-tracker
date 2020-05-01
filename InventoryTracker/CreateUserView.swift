//
//  CreateUserView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/26/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct CreateUserView: View {
	@EnvironmentObject private var dataManager: DataManager
	
	@Environment (\.presentationMode) var presentationMode
	
	@State var email: String = "kris.zabala@gmail.com"
	@State var firstName: String = "Kris"
	@State var lastName: String = "Zabala"
	@State var password: String = "123456"
	@State var showingEmailInvalid: Bool = false
	@State var showingEmailExists: Bool = false
	@State var showingPasswordInvalid: Bool = false
	@State var showingFirstNameInvalid: Bool = false
	@State var showingLastNameInvalid: Bool = false
	
	var body: some View {
		KeyboardGuardian{
			ZStack{
				VStack {
					Group{
						TextField("Email Address", text: $email).modifier(ITTextFieldStyle())
						if showingEmailInvalid {
							Text("Please enter a valid email address.")
								.foregroundColor(.red)
						}
						if showingEmailExists {
							Text("User with email already exists.")
								.foregroundColor(.red)
						}
						TextField("First Name", text: $firstName).modifier(ITTextFieldStyle())
						if showingFirstNameInvalid {
							Text("Valid first name required.")
								.foregroundColor(.red)
						}
						TextField("Last Name", text: $lastName).modifier(ITTextFieldStyle())
						if showingLastNameInvalid {
							Text("Valid last name required.")
								.foregroundColor(.red)
						}
						TextField("Password", text: $password).modifier(ITTextFieldStyle())
						if showingPasswordInvalid {
							Text("Password longer than 6 characters required.")
								.foregroundColor(.red)
						}
					}
					
					Button(action: {
						self.validateInput()
						if self.isInputValid()
						{
							print("Attempting to create User")
							let createStatus = self.dataManager.createUser(email: self.email, firstName: self.firstName, lastName: self.lastName, password: self.password)
							if (createStatus == .saveSuccess){
								print("User created successfully")
								self.presentationMode.wrappedValue.dismiss()
							}
							else if (createStatus == .saveFailedAlreadyExists){
								print("User with email \(self.email) already exists")
								self.showingEmailExists = true
							}
						}
					})
					{
						ITButton(label: "CREATE USER")
					}
					
					Button(action: {
						self.presentationMode.wrappedValue.dismiss()
					})
					{
						ITButton(label: "CANCEL")
					}
				}
			}
			.padding()
		}
	}
	
	private func validateInput(){
		if	(!email.isValidEmailAddress()){
			showingEmailInvalid = true
		}
		else{
			showingEmailInvalid = false
		}
		showingFirstNameInvalid = firstName.count == 0
		showingLastNameInvalid = lastName.count == 0
		showingPasswordInvalid = password.count < 6
	}
	
	private func isInputValid() -> Bool {
		return !(showingEmailInvalid || showingFirstNameInvalid || showingLastNameInvalid || showingPasswordInvalid)
	}
	
}

#if DEBUG
struct CreateUserView_Previews : PreviewProvider {
	static var previews: some View {
		CreateUserView().modifier(SystemServices())
	}
}
#endif

struct ITTextFieldStyle: ViewModifier{
	func body(content: Content) -> some View {
		return content
			.padding()
			.background(Palette.lightGreyColor)
			.cornerRadius(5.0)
			.padding(.top, 10)
	}
}

