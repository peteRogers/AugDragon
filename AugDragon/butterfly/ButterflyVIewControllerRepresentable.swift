//
//  ButterflyVIewControllerRepresentable.swift
//  AugDragon
//
//  Created by Peter Rogers on 18/05/2024.
//

import Foundation
import SwiftUI
import RealityKit


struct ButterflyVIewControllerRepresentable: UIViewControllerRepresentable {
var mat: Mat
var showProgress:Bool

func makeCoordinator() -> Coordinator {
	//	class Coordinator: NSObject{
	return Coordinator(self, mat: mat)
	//	}
}


class Coordinator: NSObject{
	var parent: ButterflyVIewControllerRepresentable
	var mat: Mat
	
	
	init(_ parent: ButterflyVIewControllerRepresentable, mat: Mat) {
		self.mat = mat
		self.parent = parent
		
		
	}
}

func makeUIViewController(context: Context) -> ButterflyViewController {
	let viewController = ButterflyViewController()
	viewController.coordinator = context.coordinator
	return viewController
}

func updateUIViewController(_ uiViewController: ButterflyViewController, context: Context) {
	// Update the ARView if needed
}
}
