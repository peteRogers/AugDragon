//
//  CameraController.swift
//  animationsExp
//
//  Created by Peter Rogers on 14/09/2023.
//

import SwiftUI
import AVFoundation


struct CameraViewRepresentable: UIViewControllerRepresentable {
	@ObservedObject var model: CameraViewModel
	var sampleBuffer: ((CMSampleBuffer) -> Void)?
	
	func makeUIViewController(context: Context) -> CameraViewController {
		let cvc = CameraViewController()
		cvc.sample = sampleBuffer
		context.coordinator.setupFunctionCaller(viewController: cvc)
		cvc.coordinator = context.coordinator
		return cvc
	}
	
	func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self, model: model)
	}
	
	class Coordinator: NSObject {
		var parent: CameraViewRepresentable
		var model: CameraViewModel
		init(_ parent: CameraViewRepresentable, model: CameraViewModel) {
			self.parent = parent
			self.model = model
		}
		@MainActor func imageDataChanged(newValue: CGImage){
			model.rawPhoto = newValue
		}
		
		@MainActor func setupFunctionCaller(viewController: CameraViewController) {
			model.takePhotoCaller = {
				viewController.capturePhoto()
			}
		}
	}
}
