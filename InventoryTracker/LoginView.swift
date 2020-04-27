//
//  LoginView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/24/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct LoginView: View {
	@EnvironmentObject private var dataManager: DataManager
	@Environment (\.presentationMode) var presentationMode

	@State var email: String = "kris.zabala@gmail.com"
	@State var password: String = "123456"
	@State var authenticationDidFail: Bool = false
	@State var authenticationDidSucceed: Bool = false
	@State var isShowingCreateUserView: Bool = false
	
	var body: some View {
		KeyboardGuardian{
			ZStack{
				VStack {
					WelcomeText()
					UsernameTextField(email: self.$email)
					PasswordTextField(password: self.$password)
					if self.authenticationDidFail {
						LoginFailedView()
					}
					Button(action: {
						if self.dataManager.login(email: self.email, password: self.password) {
							self.authenticationDidSucceed = true
							self.authenticationDidFail = false
						} else {
							self.authenticationDidFail = true
						}
					})
					{
						ITButton(label: "LOGIN")
					}
					
					Button(action: {
						self.isShowingCreateUserView = true
					})
					{
						ITButton(label: "CREATE USER")
					}
				}
				if authenticationDidSucceed {
					LoginSuccessView()
				}
			}
			.padding()
			.sheet(isPresented: $isShowingCreateUserView) { CreateUserView().modifier(SystemServices()) }
		}
	}
		
		
}

#if DEBUG
struct LoginView_Previews : PreviewProvider {
	static var previews: some View {
		LoginView().modifier(SystemServices())
	}
}
#endif

struct WelcomeText : View {
	var body: some View {
		return Text("Welcome!")
			.font(.largeTitle)
			.fontWeight(.semibold)
			.padding(.bottom, 20)
	}
}

struct UserImage : View {
	var body: some View {
		return Image("userImage")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 150, height: 150)
			.clipped()
			.cornerRadius(150)
			.padding(.bottom, 75)
	}
}

struct LoginButtonContent : View {
	var body: some View {
		return Text("LOGIN")
			.font(.headline)
			.foregroundColor(.white)
			.padding()
			.frame(width: 220, height: 60)
			.background(Color.green)
			.cornerRadius(15.0)
	}
}

struct UsernameTextField: View {
	@Binding var email: String
	var body: some View {
		TextField("Email", text: $email)
			.padding()
			.background(Palette.lightGreyColor)
			.cornerRadius(5.0)
			.padding(.bottom, 20)
	}
}

struct PasswordTextField: View {
	@Binding var password: String
	var body: some View {
		SecureField("Password", text: $password)
			.padding()
			.background(Palette.lightGreyColor)
			.cornerRadius(5.0)
			.padding(.bottom, 20)
	}
}

struct LoginSuccessView: View {
	var body: some View {
		Text("Login succeeded!")
			.font(.headline)
			.frame(width: 250, height: 80)
			.background(Color.green)
			.cornerRadius(20.0)
			.foregroundColor(.white)
			.animation(Animation.default)
	}
}

struct LoginFailedView: View {
	var body: some View {
		Text("Information not correct. Try again.")
			.offset(y: -10)
			.foregroundColor(.red)
	}
}
