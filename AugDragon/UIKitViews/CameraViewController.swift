//
//  CameraViewController.swift
//  vision_swiftUI
//
//  Created by Peter Rogers on 07/12/2022.
//


import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
	
	private var cameraView: CameraPreview { view as! CameraPreview }
	var sample: ((CMSampleBuffer) -> Void)?
	var coordinator: CameraViewRepresentable.Coordinator?
	
	private let videoDataOutputQueue = DispatchQueue(
		label: "CameraFeedOutput",
		qos: .userInteractive
	)
	
	private var cameraFeedSession: AVCaptureSession?
	private let photoOutput = AVCapturePhotoOutput()
	

	override func loadView() {
		view = CameraPreview()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		do {
			if cameraFeedSession == nil {
				try setupAVSession()
				cameraView.previewLayer.session = cameraFeedSession
				cameraView.previewLayer.videoGravity = .resizeAspect
				print(cameraView.previewLayer.frame)
				
			}
			DispatchQueue.global(qos: .userInitiated).async{
				self.cameraFeedSession?.startRunning()
			}
		} catch {
			print(error.localizedDescription)
		}
	
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		if cameraFeedSession?.isRunning == true {
			cameraFeedSession?.stopRunning()
		}
//
//		// Remove inputs and outputs
//		if let inputs = cameraFeedSession?.inputs {
//			for input in inputs {
//				cameraFeedSession?.removeInput(input)
//			}
//		}


		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
//		if let outputs = cameraFeedSession?.outputs {
//			for output in outputs {
//				cameraFeedSession?.removeOutput(output)
//			}
//		}
//
//		// Release the AVCaptureSession
//		cameraFeedSession = nil
	}
	
	func takePhoto(){
		print("take photo")
		self.capturePhoto()
	}
	
	func setupAVSession() throws {
		// Select a front facing camera, make an input.
		guard let videoDevice = AVCaptureDevice.default(
			.builtInWideAngleCamera,
			for: .video,
			position: .back
		)
		else {
			throw AppError.captureSessionSetup(
				reason: "Could not find a front facing camera."
			)
		}
		
		guard let deviceInput = try? AVCaptureDeviceInput(
			device: videoDevice
		) else {
			throw AppError.captureSessionSetup(
				reason: "Could not create video device input."
			)
		}
		
		let session = AVCaptureSession()
		session.beginConfiguration()
		session.sessionPreset = AVCaptureSession.Preset.high
		
		// Add a video input.
		guard session.canAddInput(deviceInput) else {
			throw AppError.captureSessionSetup(
				reason: "Could not add video device input to the session"
			)
		}
		session.addInput(deviceInput)
		
		let dataOutput = AVCaptureVideoDataOutput()
		if session.canAddOutput(dataOutput) {
			session.addOutput(dataOutput)
			
			// Add a video data output.
			dataOutput.alwaysDiscardsLateVideoFrames = true
			dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
		} else {
			throw AppError.captureSessionSetup(
				reason: "Could not add video data output to the session"
			)
		}
		if session.canAddOutput(photoOutput) {
			session.addOutput(photoOutput)
		}
		
		
		session.commitConfiguration()
		cameraFeedSession = session
	}
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate {
	func captureOutput(_ output: AVCaptureOutput,
					   didOutput sampleBuffer: CMSampleBuffer,
					   from connection: AVCaptureConnection) {
		self.sample?(sampleBuffer)
		
		
	}
	
	func capturePhoto() {
		   let photoSettings = AVCapturePhotoSettings()
		   // Configure your settings here (e.g., flash mode, auto-stabilization, etc.)
		   photoOutput.capturePhoto(with: photoSettings, delegate: self)
	   }
	
	// Delegate method for AVCapturePhotoCaptureDelegate
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		if let error = error {
			print("Error capturing photo: \(error)")
			return
		}
		
		// Retrieve the image data and process itnil
		if let imageData = photo.cgImageRepresentation() {
			
			coordinator?.imageDataChanged(newValue: imageData)
			// Use the image data, for example:
				//let image = UIImage(data: imageData)
			// Do something with the image
		}
	}
}
