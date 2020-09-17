//
//  CreateBinView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct CreateBinView: View {
	@ObservedObject var createBinVM: CreateBinVM
	@Environment(\.presentationMode) var presentationMode
	
	var parentBin: Bin?
	
	var body: some View {
		Form {
			Section(header: Text("Name")) {
				TextField("Name", text: $createBinVM.name)
				// .keyboardType(.default)
				if createBinVM.showingBinExists {
					Text("Bin with same name already exists.")
						.foregroundColor(.red)
				}
			}
				
			Section(header: Text("Notes")) {
				TextField("Notes", text: $createBinVM.notes)
				// .keyboardType(.default)
			}
				
			Button(action: {
				self.createBinVM.createBin()
			}) {
				Text("Add Bin")
			}
			Button(action: {
				self.cancelButtonAction()
			}) {
				Text("Cancel")
			}
			.navigationBarTitle("Add Bin")
			.onReceive(createBinVM.viewDismissalModePublisher) { shouldDismiss in
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

struct CreateBinView_Previews: PreviewProvider {
	static var previews: some View {
		CreateBinView(createBinVM: CreateBinVM(bin: nil))
	}
}
