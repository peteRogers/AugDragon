//
//  CameraController.swift
//  animationsExp
//
//  Created by Peter Rogers on 14/09/2023.
//

import SwiftUI
import AVFoundation


struct CameraViewRepresentable: UIViewControllerRepresentable {
//	class Coordinator: NSObject {
//		
//	}
	
	@ObservedObject var model: CameraViewModel

	var sampleBuffer: ((CMSampleBuffer) -> Void)?
	
	
	func makeUIViewController(context: Context) -> CameraViewController {
		let cvc = CameraViewController()
		cvc.sample = sampleBuffer
		context.coordinator.viewController = cvc
		//cvc.delegate = context.coordinator
		cvc.takePhoto()
		return cvc
	}
	
	func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		print("from make coordinator")
		return Coordinator(self, model: model)
	}
	
	class Coordinator: NSObject {
		var parent: CameraViewRepresentable
		var viewController: CameraViewController?
		var model: CameraViewModel

		init(_ parent: CameraViewRepresentable, model: CameraViewModel) {
			self.parent = parent
			self.model = model
		}

		// A function that the model can call
		func takePhoto() {
			print("from cvr")
			viewController?.takePhoto()
			print(viewController.debugDescription)
		}
	}
	
	
//	func callFunctionOnController(from uiViewController: MyUIViewController) {
//		uiViewController.myFunction()
//	}
	
//	func makeCoordinator() -> Coordinator {
//		   Coordinator(self, model: model)
//	   }
//	
//	class Coordinator: NSObject {
//		var parent: CameraView
//		var model: CameraViewModel
//		
//		init(_ parent: CameraView, model: CameraViewModel) {
//			self.parent = parent
//			self.model = model
//		}
//		
//		// This function can be called by the model
////		@MainActor func callFunction() {
////			// Assuming you have a reference to the UIViewController
////			if let uiViewController = model.cameraController {
////				//parent.
////				parent.callFunctionOnController(from: uiViewController)
////			}
////		}
//	}
}
