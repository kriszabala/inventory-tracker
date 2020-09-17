//
//  BinView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/27/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import CoreStore
import Resolver
import SwiftUI

struct BinsView: View {
	var dataCoordinator: DataCoordinator = Resolver.resolve()

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
	
	init(bin: Bin?) {
		if let bin = bin {
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
		ZStack {
			List {
				if csBins.snapshot.count > 0 {
					Section(header: Text("Bins")) {
						// Text(verbatim:"Debug = \(csBins.snapshot.numberOfSections)")
						ForEach(csBins.snapshot.items(inSectionWithID: csBins.snapshot.sectionIDs[0]), id: \.self) { csBin in
							HStack {
								Image(systemName: csBin.subBins!.count > 0 ? "tray.2.fill" : "tray")
									.resizable()
									.frame(width: 32, height: 32, alignment: .center)
								VStack(alignment: .leading) {
									Text("\(csBin.name!)")
										.font(.headline)
									if csBin.notes!.count > 0 {
										Text("Notes: \(csBin.notes!)")
											.font(.subheadline)
									}
								}
								Spacer()
								NavigationLink("", destination: BinsView(bin: csBin.object).navigationBarTitle(Text((csBin.object!).displayName())))
							}
						}
					}
				}
				if items.snapshot.count > 0 {
					Section(header: Text("Items")) {
						ForEach(items.snapshot.items(inSectionWithID: items.snapshot.sectionIDs[0]), id: \.self) { item in
							HStack {
								Image(uiImage: item.previewPhoto!)
									.resizable()
									.frame(width: 32, height: 32, alignment: .center)
								VStack(alignment: .leading) {
									Text("\(item.name!!)")
										.font(.headline)
									if item.notes != nil && !item.notes!!.isEmpty {
										Text("Notes: \(item.notes!!)")
											.font(.subheadline)
									}
								}
								NavigationLink("", destination:
									ItemView(itemVM: ItemVM(item: item.object, bin: self.bin)))
							}
						}
					}
				}
			}
				
			NavigationLink(destination: ItemView(itemVM: ItemVM(item: nil, bin: self.bin)), isActive: self.$pushItemView) {
				EmptyView()
			}.hidden()
			NavigationLink(destination: CreateBinView(createBinVM: CreateBinVM(parentBin: self.bin)), isActive: self.$pushBinView) {
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
						self.pushItemView = true
					}
					.onLongPressGesture(minimumDuration: 0.1) {
						self.pushBinView = true
					}
			})
		})
		.onAppear {
			// Resets photosToAdd when user did not save or presses the back button
			self.dataCoordinator.resetAllPhotos()
		}
	}
}

struct BinView_Previews: PreviewProvider {
	static var previews: some View {
		BinsView()
	}
}
