//
//  BinView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct BinsView: View {
	@EnvironmentObject private var dataManager: DataManager
	@State private var showCreateBinsSheet = false
	
	var body: some View {
		NavigationView {
			VStack{
				Text("Bins")
				Button(action: {
					self.dataManager.isLoggedIn = false;
				}){ ITButton(label: "Logout") }
			}
			.navigationBarTitle("Bins")
			.navigationBarItems(trailing: Button(action: {
				self.showCreateBinsSheet = true
			}, label: {
				Image(systemName: "plus.circle")
					.resizable()
					.frame(width: 32, height: 32, alignment: .center)
			}))
		}
	}
}

struct BinView_Previews: PreviewProvider {
	static var previews: some View {
		BinsView().modifier(SystemServices())
	}
}


