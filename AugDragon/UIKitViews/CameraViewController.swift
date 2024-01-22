//  CameraViewController.swift
//  vision_swiftUI
//  Created by Peter Rogers on 07/12/2022.
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
			}
			DispatchQueue.global(qos: .userInteractive).async{
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
		super.viewWillDisappear(animated)
	}
	
	func setupAVSession() throws {
		// Select a front facing camera, make an input.
		guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video,position: .back)
		else {
			throw AppError.captureSessionSetup(reason: "Could not find a front facing camera.")
		}
		guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice
		) else {
			throw AppError.captureSessionSetup(reason: "Could not create video device input.")
		}
		let session = AVCaptureSession()
		session.beginConfiguration()
		session.sessionPreset = AVCaptureSession.Preset.photo
		guard session.canAddInput(deviceInput) else {
			throw AppError.captureSessionSetup(reason: "Could not add video device input to the session")
		}
		session.addInput(deviceInput)
		let dataOutput = AVCaptureVideoDataOutput()
		if session.canAddOutput(dataOutput) {
			session.addOutput(dataOutput)
			dataOutput.alwaysDiscardsLateVideoFrames = true
			dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
		} else {
			throw AppError.captureSessionSetup(
				reason: "Could not add video data output to the session")
		}
		if session.canAddOutput(photoOutput) {
			photoOutput.maxPhotoQualityPrioritization = .quality
			session.addOutput(photoOutput)
		}
		session.commitConfiguration()
		cameraFeedSession = session
	}
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate {
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection) {
		self.sample?(sampleBuffer)
	}
	
	func capturePhoto() {
		
		let photoSettings = AVCapturePhotoSettings()
		photoOutput.capturePhoto(with: photoSettings, delegate: self)
		print("taken photo")
//		if(cameraFeedSession != nil){
//			cameraFeedSession?.stopRunning()
//		}
		
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		//print(photo.)
		if let error = error {
			print("Error capturing photo: \(error)")
			return
		}
		if let imageData = photo.cgImageRepresentation() {
			print(imageData.width)
			coordinator?.imageDataChanged(newValue: imageData)
		}
	}
}
