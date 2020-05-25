//
//  PhotosView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 5/25/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct PhotosView: View {
	@EnvironmentObject private var dataManager: DataManager
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	
	@State var index: Int
	@State var photos: [UIImage]
	//var images = ["test0", "test1", "test2"]
	
	
	init(index: Int ,photos: [UIImage]) {
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
		UINavigationBar.appearance().setBackgroundImage(UIColor.black.toImage()?.imageWithAlpha(alpha: 0.5), for: .default)
		_photos = State(initialValue: photos)
		_index = State(initialValue: index)
	}
	
    var body: some View {
			VStack(spacing: 20) {
				PagingView(index: $index.animation(), maxIndex: photos.count - 1) {
					ForEach(self.photos, id: \.self) { image in
						Image(uiImage: image)
							.resizable()
							.scaledToFill()
					}
				}
				.aspectRatio(4/3, contentMode: .fit)
				.clipShape(RoundedRectangle(cornerRadius: 15))
				
				PagingView(index: $index.animation(), maxIndex: photos.count - 1) {
					ForEach(self.photos, id: \.self) { image in
						Image(uiImage: image)
							.resizable()
							.scaledToFill()
					}
				}
				.aspectRatio(3/4, contentMode: .fit)
				.clipShape(RoundedRectangle(cornerRadius: 15))
				
				Stepper("Index: \(index)", value: $index.animation(.easeInOut), in: 0...photos.count-1)
					.font(Font.body.monospacedDigit())
			}
			.padding()
			.navigationBarTitle("Photo Preview", displayMode: .inline)
			.navigationBarItems(leading: PreviewCancelButton(), trailing: PreviewDoneButton())
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
			PhotosView(index:0, photos: [UIImage(named: "test0")!, UIImage(named: "test1")!, UIImage(named: "test2")!])
    }
}

struct PreviewCancelButton: View {
	@EnvironmentObject private var dataManager: DataManager
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	var body: some View {
		Button("Cancel") {
			self.viewControllerHolder?.dismiss(animated: true, completion: nil)
		}.foregroundColor(.white)
	}
}

struct PreviewDoneButton: View {
	@EnvironmentObject private var dataManager: DataManager
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	var body: some View {
		Button("Done") {
			self.viewControllerHolder?.dismiss(animated: true, completion: nil)
		}.foregroundColor(.white)
	}
}


struct PagingView<Content>: View where Content: View {
	
	@Binding var index: Int
	let maxIndex: Int
	let content: () -> Content
	
	@State private var offset = CGFloat.zero
	@State private var dragging = false
	
	init(index: Binding<Int>, maxIndex: Int, @ViewBuilder content: @escaping () -> Content) {
		self._index = index
		self.maxIndex = maxIndex
		self.content = content
	}
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			GeometryReader { geometry in
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 0) {
						self.content()
							.frame(width: geometry.size.width, height: geometry.size.height)
							.clipped()
					}
				}
				.content.offset(x: self.offset(in: geometry), y: 0)
				.frame(width: geometry.size.width, alignment: .leading)
				.gesture(
					DragGesture().onChanged { value in
						self.dragging = true
						self.offset = -CGFloat(self.index) * geometry.size.width + value.translation.width
					}
					.onEnded { value in
						let predictedEndOffset = -CGFloat(self.index) * geometry.size.width + value.predictedEndTranslation.width
						let predictedIndex = Int(round(predictedEndOffset / -geometry.size.width))
						self.index = self.clampedIndex(from: predictedIndex)
						withAnimation(.easeOut) {
							self.dragging = false
						}
					}
				)
			}
			.clipped()
			HStack{
				Spacer()
				PageControl(index: $index, maxIndex: maxIndex)
				Spacer()
			}
		}
	}
	
	func offset(in geometry: GeometryProxy) -> CGFloat {
		if self.dragging {
			return max(min(self.offset, 0), -CGFloat(self.maxIndex) * geometry.size.width)
		} else {
			return -CGFloat(self.index) * geometry.size.width
		}
	}
	
	func clampedIndex(from predictedIndex: Int) -> Int {
		let newIndex = min(max(predictedIndex, self.index - 1), self.index + 1)
		guard newIndex >= 0 else { return 0 }
		guard newIndex <= maxIndex else { return maxIndex }
		return newIndex
	}
}

struct PageControl: View {
	@Binding var index: Int
	let maxIndex: Int
	
	var body: some View {
		HStack(spacing: 8) {
			ForEach(0...maxIndex, id: \.self) { index in
				Circle()
					.fill(index == self.index ? Color.white : Color.gray)
					.frame(width: 8, height: 8)
			}
		}
		.padding(15)
	}
}

