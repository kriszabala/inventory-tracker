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
	@State private var pushItemView = false
	@State private var pushBinView = false
	var bin: ITBin?
	
	@FetchRequest(entity: ITBin.entity(),
								sortDescriptors: [NSSortDescriptor(keyPath: \ITBin.name, ascending: true)],
								predicate: NSPredicate(format: "level == %d", 0))
		var bins: FetchedResults<ITBin>
	
	@FetchRequest(entity: ITItem.entity(),
								sortDescriptors: [NSSortDescriptor(keyPath: \ITItem.name, ascending: true)],
								predicate: NSPredicate(format: "bin == nil"))
	var items: FetchedResults<ITItem>
	
	init() {
		self.init(bin: nil)
	}
	
	init(bin:ITBin?){
		if let bin = bin{
			self.bin = bin
			_bins = FetchRequest<ITBin>(fetchRequest:ITBin.getSubBinsForBin(bin: bin))
			_items = FetchRequest<ITItem>(fetchRequest:ITItem.getItemsForBin(bin: bin))
		}
	}
	
	var body: some View {
		ZStack{
		List {
			if (bins.count > 0) {
				Section(header: Text("Bins")) {
					ForEach(bins) { bin in
						HStack {
							Image(systemName: bin.subBins!.count > 0 ? "tray.2.fill" : "tray")
								.resizable()
								.frame(width: 32, height: 32, alignment: .center)
							VStack(alignment: .leading) {
								Text("\(bin.name!)")
									.font(.headline)
								if (bin.notes != nil){
									Text("Notes: \(bin.notes!)")
										.font(.subheadline)
								}
							}
							Spacer()
							NavigationLink("", destination: BinsView(bin: bin).navigationBarTitle(Text(self.dataManager.displayNameForBin(bin: bin))))
							
						}
					}
				}
			}
			if (items.count > 0) {
				Section(header: Text("Items")) {
					ForEach(items) { item in
						HStack {
							Image(systemName: "eye")
								.resizable()
								.frame(width: 32, height: 32, alignment: .center)
							VStack(alignment: .leading) {
								Text("\(item.name!)")
									.font(.headline)
								if (item.notes != nil){
									Text("Item: \(item.notes!)")
										.font(.subheadline)
								}
							}
							NavigationLink("", destination:
								ItemView(item:item).modifier(SystemServices()))
						}
					}
				}
			}
		}
			NavigationLink(destination: ItemView(bin:self.bin).modifier(SystemServices()), isActive: self.$pushItemView) {
				Text("")
			}.hidden()
			NavigationLink(destination: CreateBinView(parentBin: self.bin).modifier(SystemServices()), isActive: self.$pushBinView) {
				Text("")
			}.hidden()
		}
			
		.navigationBarItems(trailing: Button(action: {}, label: {
				Image(systemName: "plus.circle")
					.resizable()
					.frame(width: 32, height: 32, alignment: .center)
					.onTapGesture {
						print("Add Item")
						self.pushItemView = true
				}
				.onLongPressGesture(minimumDuration: 0.1) {
					self.pushBinView = true
				}}))
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


