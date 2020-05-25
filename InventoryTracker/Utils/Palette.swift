//
//  Palette.swift
//  InventoryTracker
//
//  Created by Kris Zabala on 4/24/20.
//  Copyright © 2020 Zabala. All rights reserved.
//

import Foundation
import SwiftUI

func ColorFromRGB(rgb: UInt) -> Color {
	return Color(
		red: Double((rgb & 0xFF0000) >> 16) / 255.0,
		green: Double((rgb & 0x00FF00) >> 8) / 255.0,
		blue: Double(rgb & 0x0000FF) / 255.0
	)
}

struct Palette {
	/* Put all your colors here */
	
	static let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
	
	
	/* And your gradients! */
	static let skyGradient = Gradient(colors: [
		ColorFromRGB(rgb: 0xDEC72E), ColorFromRGB(rgb: 0xE6E67D)
	])
	static let landGradient = Gradient(colors: [
		ColorFromRGB(rgb: 0xFAA287), ColorFromRGB(rgb: 0x954227)
	])
	static let rayGradient = Gradient(colors: [
		ColorFromRGB(rgb: 0xFFE961), ColorFromRGB(rgb: 0xFFFDED)
	])
	static let sunGradient = Gradient(colors: [
		ColorFromRGB(rgb: 0xFFFBA1), ColorFromRGB(rgb: 0xF7CE58)
	])
	
	static let whiteToBlackGradient = Gradient(colors: [
		ColorFromRGB(rgb: 0xFFFFFF).opacity(0.4), ColorFromRGB(rgb: 0x000000).opacity(0.8)
	])
}
