//
//  SettingsView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var dataManager: DataManager
	
	var body: some View {
		NavigationView {
			VStack{
				Text("Settings")
				Button(action: {
					self.dataManager.isLoggedIn = false;
				}){ ITButton(label: "Logout") }
				Button(action: {
					self.dataManager.reset()
				}){ ITButton(label: "Reset") }
			}.navigationBarTitle("Settings")
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().modifier(SystemServices())
    }
}
