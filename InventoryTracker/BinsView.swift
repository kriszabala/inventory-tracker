//
//  BinView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI
import CoreStore

struct BinsView: View {
	@EnvironmentObject private var dataManager: DataManager
	
	@ObservedObject
	var csBins: ListPublisher<Bin> = CoreStoreDefaults.dataStack.publishList(
		From<Bin>()
			.where(\.$level == 0)
			.orderBy(.ascending(\.$name))
	)
	
	@ObservedObject
	var items: ListPublisher<Item> = CoreStoreDefaults.dataStack.publishList(
		From<Item>()
			.where(\.$bin == nil)
			.orderBy(.ascending(\.$name))
	)
	
	@State private var pushItemView = false
	@State private var pushBinView = false
	var bin: Bin?
	
	init() {
		self.init(bin: nil)
	}
	
	init(bin:Bin?){
		if let bin = bin{
			self.bin = bin
			csBins = CoreStoreDefaults.dataStack.publishList(
				From<Bin>()
					.where(\.$parentBin == bin)
					.orderBy(.ascending(\.$name))
			)
			
			items = CoreStoreDefaults.dataStack.publishList(
				From<Item>()
					.where(\.$bin == bin)
					.orderBy(.ascending(\.$name))
			)
		}
	}
	
	var body: some View {
		ZStack{
			List {
			if (self.csBins.snapshot.count > 0) {
				Section(header: Text("Bins")) {
					//Text(verbatim:"Debug = \(csBins.snapshot.numberOfSections)")
					ForEach(self.csBins.snapshot.items(inSectionWithID: self.csBins.snapshot.sectionIDs[0]), id: \.self) { csBin in
						HStack {
							Image(systemName: csBin.subBins!.count > 0 ? "tray.2.fill" : "tray")
								.resizable()
								.frame(width: 32, height: 32, alignment: .center)
							VStack(alignment: .leading) {
								Text("\(csBin.name!)")
									.font(.headline)
								if (csBin.notes!.count > 0){
									Text("Notes: \(csBin.notes!)")
										.font(.subheadline)
								}
								
							}
							Spacer()
							NavigationLink("", destination: BinsView(bin: csBin.object).navigationBarTitle(Text(self.dataManager.displayNameForBin(bin: csBin.object!))))
						}
					}
				}
			}
			if (items.snapshot.count > 0) {
				Section(header: Text("Items")) {
					ForEach(self.items.snapshot.items(inSectionWithID: self.items.snapshot.sectionIDs[0]), id: \.self) { item in
						HStack {
							Image(uiImage:item.previewPhoto!)
								.resizable()
								.frame(width: 32, height: 32, alignment: .center)
							VStack(alignment: .leading) {
								Text("\(item.name!!)")
									.font(.headline)
								if (item.notes != nil && !item.notes!!.isEmpty) {
									Text("Notes: \(item.notes!!)")
										.font(.subheadline)
								}
							}
							NavigationLink("", destination:
								ItemView(item:item.object).modifier(SystemServices()))
						}
					}
				}
			}
		}
				
			NavigationLink(destination: ItemView(bin:self.bin).modifier(SystemServices()), isActive: self.$pushItemView) {
				EmptyView()
			}.hidden()
			NavigationLink(destination: CreateBinView(parentBin: self.bin).modifier(SystemServices()), isActive: self.$pushBinView) {
				EmptyView()
			}.hidden()
		}
			
		.navigationBarItems(trailing: HStack {
			Text("Tap to add item, hold to add bin \u{2794}")
			Button(action: {}, label: {
				Image(systemName: "plus.circle")
					.resizable()
					.frame(width: 32, height: 32, alignment: .center)
					.onTapGesture {
						print("Add Item")
						self.pushItemView = true
				}
				.onLongPressGesture(minimumDuration: 0.1) {
					self.pushBinView = true
				}})
			})
		.onAppear(){
			//Resets photosToAdd when user did not save or presses the back button
			self.dataManager.resetAllPhotos()
		}
	}
}

struct BinView_Previews: PreviewProvider {
	static var previews: some View {
		BinsView().modifier(SystemServices())
	}
}


