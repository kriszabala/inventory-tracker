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
	var bin: ITBin?
	
	@FetchRequest(entity: ITBin.entity(),
								sortDescriptors: [NSSortDescriptor(keyPath: \ITBin.name, ascending: true)],
								predicate: NSPredicate(format: "level == %d", 0))
	
	//@FetchRequest(fetchRequest: ITBin.fetchRequest())
	var bins: FetchedResults<ITBin>
	
	init() {
		self.init(bin: nil)
	}
	
	init(bin:ITBin?){
		self.bin = bin
		if let bin = bin{
			_bins = FetchRequest<ITBin>(fetchRequest:ITBin.getSubBinsForParent(parentBin: bin))
		}
	}
	
	var body: some View {
			List {
				ForEach(bins) { bin in
					HStack {
						Image(systemName: bin.subBins!.count > 0 ? "tray.2.fill" : "tray")
							.resizable()
							.frame(width: 32, height: 32, alignment: .center)
						VStack(alignment: .leading) {
							Text("\(bin.name!) - \(bin.level)")
								.font(.headline)
							if (bin.notes != nil){
							Text("Notes: \(bin.notes!)")
								.font(.subheadline)
							}
						}
						Spacer()
						NavigationLink("", destination: BinsView(bin: bin).navigationBarTitle(Text("\(bin.name ?? "")")))
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
		BinsView().modifier(SystemServices())
	}
}


