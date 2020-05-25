//
//  Helper.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/26/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

extension Binding where Value == Bool {
	public func negate() -> Binding<Bool> {
		return Binding<Bool>(get:{ !self.wrappedValue },
												 set: { self.wrappedValue = !$0})
	}
}

extension String {
	
	/// Checks if the `String` is a valid email address.
	/// ````
	/// // Example
	/// "name@email.com".isValidEmailAddress() // true
	/// "name(at)email(dot)com".isValidEmailAddress() // false
	/// "name@email".isValidEmailAddress() // false
	/// "name@.com".isValidEmailAddress() // false
	/// "name.com".isValidEmailAddress() // false
	/// ````
	/// - Note: GitHubGist: [darthpelo/EmailValidator.swift](https://gist.github.com/darthpelo/dfe3c460585f4f035c24ede994faeb80#file-emailvalidator-swift)
	func isValidEmailAddress() -> Bool {
		let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
			+ "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
			+ "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
			+ "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
			+ "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
			+ "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
			+ "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
		
		let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
}


struct ITButton: View {
	var label: String
	var body: some View {
		Text("\(label)")
			.font(.headline)
			.foregroundColor(.white)
			.frame(width: 220, height: 60)
			.background(Color.green)
			.cornerRadius(15.0)
			.padding(.top, 20)
	}
}

extension UIColor {
	func toImage() -> UIImage? {
		return toImageWithSize(size: CGSize(width: 1, height: 1))
	}
	func toImageWithSize(size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContext(size)
		
		if let ctx = UIGraphicsGetCurrentContext() {
			let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
			ctx.setFillColor(self.cgColor)
			ctx.addRect(rectangle)
			ctx.drawPath(using: .fill)
			let colorImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return colorImage
		} else {
			return nil
		}
	}
}

extension UIImage {
	func imageWithAlpha(alpha: CGFloat) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
