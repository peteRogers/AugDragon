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
	var mat: Mat
	
	func makeCoordinator() -> Coordinator {
		//	class Coordinator: NSObject{
		return Coordinator(self, mat: mat)
		//	}
	}
	
	class Coordinator: NSObject{
		var parent: FacePaintViewRepresentable
		var mat: Mat
		init(_ parent: FacePaintViewRepresentable, mat: Mat) {
			self.mat = mat
			self.parent = parent
		}
	}
		
	
	func makeUIView(context: Context) -> some UIView {
		let arView = ARSCNView(frame: .zero)
		
		arDelegate.setARView(arView)
		arDelegate.coordinator = context.coordinator
		return arView
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}

//struct FacePaintViewRepresentable_Previews: PreviewProvider {
//	static var previews: some View {
//		FacePaintViewRepresentable(arDelegate: FacePaintModel())
//	}
//}

