//
//  HostingController.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 5/6/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

class HostingController: UIHostingController<AnyView> {
	
	@objc override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
