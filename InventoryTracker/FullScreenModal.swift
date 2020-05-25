//
//  FullScreenModal.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 5/25/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Foundation
import SwiftUI


struct ViewControllerHolder {
	weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
	static var defaultValue: ViewControllerHolder {
		return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
		
	}
}

extension EnvironmentValues {
	var viewController: UIViewController? {
		get { return self[ViewControllerKey.self].value }
		set { self[ViewControllerKey.self].value = newValue }
	}
}

extension UIViewController {
	func present<Content: View>(style: UIModalPresentationStyle = .automatic, @ViewBuilder builder: () -> Content) {
		let toPresent = HostingController(rootView: AnyView(EmptyView()))
		toPresent.modalPresentationStyle = style
		toPresent.rootView = AnyView(
			builder()
				.environment(\.viewController, toPresent)
		)
		self.present(toPresent, animated: true, completion: nil)
	}
}

