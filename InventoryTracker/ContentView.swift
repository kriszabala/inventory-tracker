//
//  ContentView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/24/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var dataManager: DataManager
	@State var isLoggedIn = true
	
    var body: some View {
			
			
			TabView {
				NavigationView{
					BinsView().navigationBarTitle("Home")
				}
				.navigationViewStyle(StackNavigationViewStyle())
				.tabItem {
					Image(systemName: "1.square.fill")
					Text("Bins")
				}
				Text("Another Tab")
					.tabItem {
						Image(systemName: "2.square.fill")
						Text("Second")
				}
				SettingsView()
					.tabItem {
						Image(systemName: "3.square.fill")
						Text("Settings")
				}
			}
			.font(.headline)
			.sheet(isPresented: $dataManager.isLoggedIn.negate()) { LoginView().modifier(SystemServices()) }
			}
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
			ContentView().modifier(SystemServices())
    }
}
