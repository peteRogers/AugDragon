//
//  ImageEditView.swift
//  AugDragon
//
//  Created by Peter Rogers on 05/02/2024.
//

import Foundation
import SwiftUI

struct ImageEditView: View{
	var cvm:CameraViewModel
	@State private var whiteValue: Double = 0.5
	@State private var contrastValue: Double = 0.5
	var body: some View{
		VStack{
			Text("white balance")
				.font(.caption) // Sets the font to the title size.
				.foregroundColor(.accentColor) // Sets the text color to blue.
				.fontWeight(.regular) // Makes the text bold.
			Slider(
				value: $whiteValue,
				in: 0...1, // Specifies the range from 0 to 100
				step: 0.1, // Increment by 1
				onEditingChanged: { editing in
					// Action to perform when editing starts or stops
					print("Slider editing: \(editing)")
				}
			).padding(.bottom, 10)
			Text("contrast")
				.font(.caption) // Sets the font to the title size.
				.foregroundColor(.accentColor) // Sets the text color to blue.
				.fontWeight(.regular) // Makes the text bold.
			Slider(
				value: $contrastValue,
				in: 0...1, // Specifies the range from 0 to 100
				step: 0.1, // Increment by 1
				onEditingChanged: { editing in
					// Action to perform when editing starts or stops
					print("Slider editing: \(editing)")
				}
			).padding(.bottom, 10)
			
			
		}
	}
}
