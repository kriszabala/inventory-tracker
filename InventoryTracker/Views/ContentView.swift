//
//  ContentView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/24/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject private var contentVM = ContentVM()

	var body: some View {
		TabView {
			NavigationView {
				BinsView().navigationBarTitle("Home")
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.tabItem {
				Text("Bins")
			}
			SettingsView()
				.tabItem {
					Text("Settings")
				}
		}
		.font(.headline)
		.sheet(isPresented: $contentVM.isLoginPresented) {
			LoginView().presentation(isModal: true)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
