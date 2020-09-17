//
//  CreateItemView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/30/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CoreStore
import SwiftUI

struct ItemView: View {
	@ObservedObject var itemVM: ItemVM
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?

	var body: some View {
		ZStack {
			Form {
				Section {
					ScrollView(.horizontal, content: {
						HStack {
							Button("Add Photo") {
								self.viewControllerHolder?.present(style: .fullScreen) {
									NavigationView {
										SwiftUICamView()
									}.navigationViewStyle(StackNavigationViewStyle())
								}
							}
							.foregroundColor(.white)
							.padding()
							.background(Color.accentColor)
							.cornerRadius(8)
							ForEach(0..<itemVM.photos.count) { index in
								Image(uiImage: self.itemVM.photos[index])
									.resizable()
									.aspectRatio(contentMode: .fit)
									.onTapGesture {
										self.viewControllerHolder?.present(style: .fullScreen) {
											NavigationView {
												PhotosView(index: index, photos: self.itemVM.photos)
											}.navigationViewStyle(StackNavigationViewStyle())
										}
									}
							}
							ForEach(0..<itemVM.photosToAdd.count, id: \.self) { index in
								Image(uiImage: self.itemVM.photosToAdd[index])
									.resizable()
									.aspectRatio(contentMode: .fit)
							}
						}
						.padding(.leading, 10)
					})
						.frame(height: 100)
				}
				Section(header: Text("Name")) {
					TextField("Name", text: $itemVM.name)
					// .keyboardType(.default)
					if itemVM.showingItemExists {
						Text("Item with same name already exists.")
							.foregroundColor(.red)
					}
				}
				Section(header: Text("Quantity")) {
					Stepper("\(itemVM.quantity)", value: $itemVM.quantity, in: 1 ... 12)
				}

				Section(header: Text("Notes")) {
					TextField("Notes", text: $itemVM.notes)
					// .keyboardType(.default)
				}

				Button(action: {
					self.itemVM.createItem()
				}) {
					Text(itemVM.editMode ? "Save" : "Add Item")
				}
				Button(action: {
					self.cancelButtonAction()
				}) {
					Text("Cancel")
				}
			}.navigationBarTitle(itemVM.editMode ? "" : "Add Item")
				.onReceive(itemVM.viewDismissalModePublisher) { shouldDismiss in
					if shouldDismiss {
						self.dismiss()
					}
				}
		}
	}

	private func dismiss() {
		presentationMode.wrappedValue.dismiss()
	}

	private func cancelButtonAction() {
		dismiss()
	}
}

struct ItemView_Previews: PreviewProvider {
	static var previews: some View {
		return ItemView(itemVM: ItemVM(item: nil, bin: nil))
	}
}
