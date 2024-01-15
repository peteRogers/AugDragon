//
//  FacePaintView.swift
//  AugDragon
//
//  Created by Peter Rogers on 11/01/2024.
//

import ARKit
import SwiftUI

struct FacePaintViewRepresentable: UIViewRepresentable {
	let arDelegate:FacePaintModel
	
	func makeUIView(context: Context) -> some UIView {
		let arView = ARSCNView(frame: .zero)
		arDelegate.setARView(arView)
		return arView
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}

struct FacePaintViewRepresentable_Previews: PreviewProvider {
	static var previews: some View {
		FacePaintViewRepresentable(arDelegate: FacePaintModel())
	}
}
