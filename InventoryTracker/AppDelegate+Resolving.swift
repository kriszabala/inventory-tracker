//
//  AppDelegate+Resolving.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 9/16/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
	public static func registerAllServices() {
		register { CoreDataCoordinator() as DataCoordinator }.scope(application)
	}
}
