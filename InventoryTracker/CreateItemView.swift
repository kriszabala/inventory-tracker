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
	
	@State var name: String = "Item1"
	@State var notes: String = "note1"
	@State var quantity: Int32 = 1
	@State var showingItemExists: Bool = false
	
	var bin: ITBin?
	
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
				Section(header: Text("Quantity")) {
						Stepper("\(quantity)", value: $quantity, in: 1...12)
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
		let createStatus = self.dataManager.createItem(name: name, bin: bin, quantity: quantity, notes: notes, price: 0.00, minLevel: 0, barcode: nil)
		if (createStatus == .createSuccess){
			self.presentationMode.wrappedValue.dismiss()
		}
		else if (createStatus == .createFailedAlreadyExists){
			self.showingItemExists = true
		}
	}
	
	private func cancelButtonAction(){
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct CreateItemView_Previews: PreviewProvider {
    static var previews: some View {
			CreateItemView()
    }
}
