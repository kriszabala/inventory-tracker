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
	
	@State var name: String
	@State var notes: String
	@State var quantity: Int32
	@State var showingItemExists: Bool = false
	
	var bin: ITBin?
	var item: ITItem?
	
	init(item:ITItem? = nil, bin:ITBin? = nil) {
		self.item = item
		self.bin = bin
		if let item = item{
			_name = State(initialValue:item.name!)
			_notes = State(initialValue:item.notes ?? "")
			_quantity = State(initialValue:item.quantity)
		}
		else{
			_name = State(initialValue:"Item")
			_notes = State(initialValue:"Note")
			_quantity = State(initialValue:1)
		}
	}
	
	var body: some View {
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
				Text(self.item != nil ? "Save" : "Add Item")
			}
			Button(action: {
				self.cancelButtonAction()
			}) {
				Text("Cancel")
			}
		
		}
	}
	
	private func createButtonAction() {
		let createStatus = self.dataManager.createOrUpdateItem(item:self.item, name: name, bin: bin, quantity: quantity, notes: notes, price: 0.00, minLevel: 0, barcode: nil)
		if (createStatus == .saveSuccess) {
			self.presentationMode.wrappedValue.dismiss()
		}
		else if (createStatus == .saveFailedAlreadyExists) {
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
