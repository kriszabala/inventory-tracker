//
//  CreateItemView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI
import CoreStore

struct ItemView: View {
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	@EnvironmentObject private var dataManager: DataManager
	@Environment (\.presentationMode) var presentationMode
	
	@State var name: String
	@State var notes: String
	@State var quantity: Int32
	@State var showingItemExists: Bool = false
	@State var photos: [UIImage]
	
	var bin: Bin?
	var item: Item?
	
	init(item:Item? = nil, bin:Bin? = nil) {
		self.item = item
		self.bin = bin
		if let item = item{
			_name = State(initialValue:item.name!)
			_notes = State(initialValue:item.notes ?? "")
			_quantity = State(initialValue:item.quantity)
			_photos = State(initialValue: item.photoArray)
		}
		else{
			_name = State(initialValue:"Item")
			_notes = State(initialValue:"Note")
			_quantity = State(initialValue:1)
			_photos = State(initialValue: [])
		}
	}
	
	var body: some View {
		ZStack {
			Form {
				Section() {
					ScrollView(.horizontal, content: {
						HStack{
							Button("Add Photo") {
								self.viewControllerHolder?.present(style: .fullScreen) {
									NavigationView {
										SwiftUICamView().modifier(SystemServices())
									}.navigationViewStyle(StackNavigationViewStyle())
								}
							}
							.foregroundColor(.white)
							.padding()
							.background(Color.accentColor)
							.cornerRadius(8)
							ForEach(0..<photos.count) { index in
								Image(uiImage: self.photos[index])
									.resizable()
									.aspectRatio(contentMode: .fit)
									.onTapGesture {
										self.viewControllerHolder?.present(style: .fullScreen) {
											NavigationView {
												PhotosView(index:index, photos: self.photos).modifier(SystemServices())
											}.navigationViewStyle(StackNavigationViewStyle())
										}
								}
							}
							ForEach(0..<dataManager.photosToAdd.count, id: \.self) { index in
								Image(uiImage: self.dataManager.photosToAdd[index])
									.resizable()
									.aspectRatio(contentMode: .fit)
							}
						}
						.padding(.leading, 10)
					})
						.frame(height: 100)
					
					
				}
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
	}
	
	private func createButtonAction() {
		let createStatus = self.dataManager.createOrUpdateItem(item:item, name: name, bin: bin, quantity: quantity, notes: notes, price: 0.00, minLevel: 0, barcode: nil)
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

struct ItemView_Previews: PreviewProvider {
	static var previews: some View {
		return ItemView(item: Item.testItem(), bin: nil).environmentObject(DataManager())
	}
}
