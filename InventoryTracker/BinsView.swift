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
	
	var body: some View {
		NavigationView {
			VStack{
				Text("Bins")
				Button(action: {
					self.dataManager.isLoggedIn = false;
				})
				{
					ITButton(label: "Logout")
				}
			}.navigationBarTitle("Bins")
		}
	}
}

struct BinView_Previews: PreviewProvider {
	static var previews: some View {
		BinsView()
	}
}


