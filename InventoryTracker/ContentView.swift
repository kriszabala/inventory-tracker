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
					Text("Bins")
				}
				SettingsView()
				.tabItem {
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
