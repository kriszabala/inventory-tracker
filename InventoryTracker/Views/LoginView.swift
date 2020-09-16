//
//  LoginView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/24/20.
//  Copyright © 2020 Zabala. All rights reserved.
//
import SwiftUI

struct LoginView: View {
	@ObservedObject var loginVM = LoginVM()
	
	var titleView: some View {
		Text("Welcome!")
			.font(.largeTitle)
			.fontWeight(.semibold)
			.padding(.bottom, 20)
	}
	
	var userImageView: some View {
		Image("userImage")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 150, height: 150)
			.clipped()
			.cornerRadius(150)
			.padding(.bottom, 75)
	}
	
	var emailTextView: some View {
		TextField("Email", text: $loginVM.email)
			.padding()
			.background(Palette.lightGreyColor)
			.cornerRadius(5.0)
			.padding(.bottom, 20)
	}
	
	var passwordTextView: some View {
		SecureField("Password", text: $loginVM.password)
			.padding()
			.background(Palette.lightGreyColor)
			.cornerRadius(5.0)
			.padding(.bottom, 20)
	}
	
	var loginFailedView: some View {
		Text(loginVM.loginMessage)
			.offset(y: -10)
			.foregroundColor(.red)
	}
	
	var loginButton: some View {
		Button(action: {
			self.loginVM.login()
		}) {
			ITButton(label: "LOGIN")
		}
	}
	
	var createUserButton: some View {
		Button(action: {
			self.loginVM.createUser()
		}) {
			ITButton(label: "CREATE USER")
		}
	}
	
	var body: some View {
		KeyboardGuardian {
			ZStack {
				VStack {
					self.titleView
					self.emailTextView
					self.passwordTextView
					if !loginVM.loginMessage.isEmpty {
						self.loginFailedView
					}
					self.loginButton
					self.createUserButton
				}
			}
			.padding()
			.sheet(isPresented: $loginVM.isShowingCreateUserView) { CreateUserView() }
		}
	}
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
#endif
