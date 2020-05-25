//
//  SwiftUICamView.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 5/6/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import SwiftUI

struct SwiftUICamView: View {
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	@ObservedObject var events = UserEvents()
	
	init() {
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
		UINavigationBar.appearance().setBackgroundImage(UIColor.black.toImage()?.imageWithAlpha(alpha: 0.5), for: .default)
	}
	
	var body: some View {
		ZStack {
			CameraView(events: self.events, applicationName: "SwiftUICam").edgesIgnoringSafeArea(.all)
			CameraInterfaceView(events: self.events)
		}
		.navigationBarTitle("Snap Pictures", displayMode: .inline)
		.navigationBarItems(leading: CamCancelButton(), trailing: CamSkipButton())
	}
}

struct SwiftUICamView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUICamView()
	}
}

struct CameraInterfaceView: View, CameraActions {
	@ObservedObject var events: UserEvents
	
	var body: some View {
		ZStack{
			VStack {
				Spacer()
				Rectangle().fill(LinearGradient(gradient: Palette.whiteToBlackGradient, startPoint: .top, endPoint: .bottom)).frame(height: 100)
			}
			VStack {
				Spacer()
				HStack {
					Image(systemName: "camera.rotate")
						.resizable()
						.aspectRatio(contentMode: .fill)
						.padding(.leading, 35)
						.foregroundColor(.white)
						.frame(width: 36, height: 36, alignment: .center).onTapGesture {
							self.rotateCamera(events: self.events)
					}
					Spacer()
					Image(systemName: "camera.circle")
						.resizable()
						.frame(width: 64, height: 64, alignment: .center)
						.foregroundColor(.white)
						.onTapGesture {
							self.takePhoto(events: self.events)
					}
					Spacer()
					Image(systemName: "bolt")
						.resizable()
						.aspectRatio(contentMode: .fill)
						.padding(.trailing, 30)
						.foregroundColor(.white)
						.frame(width: 36, height: 36, alignment: .center).onTapGesture {
							self.changeFlashMode(events: self.events)
					}
				}.padding(.bottom, 20)
			}
		}
	}
}

struct CamCancelButton: View {
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	var body: some View {
		Button("Cancel") {
			self.viewControllerHolder?.dismiss(animated: true, completion: nil)
		}.foregroundColor(.white)
	}
}

struct CamSkipButton: View {
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	var body: some View {
		Button("Skip") {
			self.viewControllerHolder?.dismiss(animated: true, completion: nil)
		}.foregroundColor(.white)
	}
}
