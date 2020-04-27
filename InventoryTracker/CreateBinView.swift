//
//  CreateBinView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct CreateBinView: View {
	@EnvironmentObject private var dataManager: DataManager
	@Environment (\.presentationMode) var presentationMode
	
	@State var name: String = ""
	@State var notes: String = ""
	@State var showingBinExists: Bool = false
	
	var parentBin: ITBin?
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Name")) {
						TextField("Name", text: $name)
						//.keyboardType(.default)
						if showingBinExists {
							Text("Bin with same name already exists.")
								.foregroundColor(.red)
						}
				}
					
					Section(header: Text("Notes")) {
						TextField("Notes", text: $notes)
						//.keyboardType(.default)
					}
					
					Button(action: {
						let level: Int16
						if let parentBin = self.parentBin{
							level = parentBin.level + 1
						}
						else{
							level = 0
						}
						
						let createStatus = self.dataManager.createBin(name: self.name, level: level, notes: self.notes)
						if (createStatus == .createSuccess){
							self.presentationMode.wrappedValue.dismiss()
						}
						else if (createStatus == .createFailedAlreadyExists){
							self.showingBinExists = true
						}
					}) {
						Text("Add Bin")
					}
					.navigationBarTitle("Add Bin")
				}
			}
    }
}

struct CreateBinView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBinView()
    }
}
