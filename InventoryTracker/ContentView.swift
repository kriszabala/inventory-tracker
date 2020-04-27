//
//  ContentView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/24/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var dataManager: DataManager
	@State var isLoggedIn = true
	
    var body: some View {
			
			
			TabView {
				VStack{
					Text("The First Tab")
					Button(action: {
						self.dataManager.isLoggedIn = false;
					})
					{
						Text("LOGOUT")
							.font(.headline)
							.foregroundColor(.white)
							.padding()
							.frame(width: 220, height: 60)
							.background(Color.green)
							.cornerRadius(15.0)
					}
				}
					.tabItem {
						Image(systemName: "1.square.fill")
						Text("First")
				}
				Text("Another Tab")
					.tabItem {
						Image(systemName: "2.square.fill")
						Text("Second")
				}
				Text("The Last Tab")
					.tabItem {
						Image(systemName: "3.square.fill")
						Text("Third")
				}
			}
			.font(.headline)
			.sheet(isPresented: $dataManager.isLoggedIn.negate()) { LoginView().environmentObject(self.dataManager) }
			}
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
			ContentView().environmentObject(DataManager())
    }
}
