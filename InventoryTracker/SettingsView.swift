//
//  SettingsView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var dataManager: DataManager
	
	var body: some View {
		NavigationView {
			VStack{
				Text("Settings")
				ITButton(label: "Logout")
			}.navigationBarTitle("Settings")
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
