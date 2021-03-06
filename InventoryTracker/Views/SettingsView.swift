//
//  SettingsView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Resolver
import SwiftUI

struct SettingsView: View {
	var dataCoordinator: DataCoordinator = Resolver.resolve()

	var body: some View {
		NavigationView {
			VStack {
				Text("Settings")
				Button(action: {
					self.dataCoordinator.logout()
				}) { ITButton(label: "Logout") }
				Button(action: {
					self.dataCoordinator.resetAllData()
				}) { ITButton(label: "Reset") }
			}.navigationBarTitle("Settings")
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
