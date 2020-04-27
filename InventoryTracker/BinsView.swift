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
	@State private var showCreateBinsSheet = false
	var level: Int16
	var bin: ITBin?
	
	@FetchRequest(fetchRequest: ITBin.fetchRequest())
	var bins: FetchedResults<ITBin>
	
	init(level: Int16){
		self.level = level
		_bins = FetchRequest<ITBin>(fetchRequest:ITBin.getBinsForLevel(level: level))
	}
	
	init(level: Int16, bin:ITBin?){
		self.level = level
		self.bin = bin
		if let bin = bin{
			_bins = FetchRequest<ITBin>(fetchRequest:ITBin.getSubBinsForParent(parentBin: bin))
		}else{
			_bins = FetchRequest<ITBin>(fetchRequest:ITBin.getBinsForLevel(level: level))
		}
	}
	
	var body: some View {
			List {
				ForEach(bins) { bin in
					HStack {
						VStack(alignment: .leading) {
							Text("\(bin.name!) - \(bin.level)")
								.font(.headline)
							if (bin.notes != nil){
							Text("Notes: \(bin.notes!)")
								.font(.subheadline)
							}
						}
						Spacer()
						NavigationLink("", destination: BinsView(level: bin.level+1, bin: bin).navigationBarTitle(Text("\(bin.name ?? "")")))
					}
				}
				.onDelete { indexSet in
					for index in indexSet {
						//self.managedObjectContext.delete(self.orders[index])
					}
				}
			}
			.navigationBarItems(trailing: Button(action: {
				self.showCreateBinsSheet = true
			}, label: {
				Image(systemName: "plus.circle")
					.resizable()
					.frame(width: 32, height: 32, alignment: .center)
			}))
				.sheet(isPresented: $showCreateBinsSheet) { CreateBinView(parentBin: self.bin).modifier(SystemServices()) }
		
	}
}

struct BinView_Previews: PreviewProvider {
	static var previews: some View {
		BinsView(level: 0).modifier(SystemServices())
	}
}


