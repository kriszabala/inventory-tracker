//
//  CreateItemView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct CreateItemView: View {
	@EnvironmentObject private var dataManager: DataManager
	@Environment (\.presentationMode) var presentationMode
	
	@State var name: String = ""
	@State var notes: String = ""
	@State var showingItemExists: Bool = false
	
	var bin: ITBin
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Name")) {
					TextField("Name", text: $name)
					//.keyboardType(.default)
					if showingItemExists {
						Text("Item with same name already exists.")
							.foregroundColor(.red)
					}
				}
				
				Section(header: Text("Notes")) {
					TextField("Notes", text: $notes)
					//.keyboardType(.default)
				}
				
				Button(action: {
					self.createButtonAction()
				}) {
					Text("Add Item")
				}
				Button(action: {
					self.cancelButtonAction()
				}) {
					Text("Cancel")
				}
				.navigationBarTitle("Add Item")
			}
		}
	}
	
	private func createButtonAction(){
	
	}
	
	private func cancelButtonAction(){
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct CreateItemView_Previews: PreviewProvider {
    static var previews: some View {
			CreateItemView(bin: ITBin())
    }
}
