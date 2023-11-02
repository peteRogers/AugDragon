//
//  CameraController.swift
//  animationsExp
//
//  Created by Peter Rogers on 14/09/2023.
//

import SwiftUI
import AVFoundation


struct CameraView: UIViewControllerRepresentable {
	var sampleBuffer: ((CMSampleBuffer) -> Void)?
	
	func makeUIViewController(context: Context) -> CameraViewController {
		let cvc = CameraViewController()
		cvc.sample = sampleBuffer
		return cvc
	}
	
	func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
		
	}
}
