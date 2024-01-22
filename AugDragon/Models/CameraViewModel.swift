//
//  CameraViewModel.swift
//  animationsExp
//
//  Created by Peter Rogers on 15/09/2023.
//

import Foundation
import AVFoundation
import Vision
import UIKit

@MainActor class CameraViewModel: ObservableObject{
	
	let visionAnalyser = VisionAnalyserModel()
	@Published var viewState = ViewState.showPhotoPreview
	@Published var capturedPhotoPreview:UIImage?
	@Published var qrPreviewState:QRDetection?
	@Published var savedArray:[ItemEntry] = []
	var takePhotoCaller: (() -> Void)?
	@Published var showProgress = false
	
	func callTakePhotoFunctionInUIKIT() {
		takePhotoCaller?()
		self.viewState = .showPhotoPreview
	}
//	
//	func tryToSaveMask(){
//		do{
//			try saveMask()
//		}catch{
//			print(error)
//			//do stuff here that handles mask cannot be saved
//		}
//	}
	
//
//	func launchRealityView(){
//		showProgress = true
////		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//			self.viewState = .showMaskView
////		}
//	
//		
//		DispatchQueue.main.async {
//			do{
//				try self.saveMask()
//			}catch{
//				print(error)
//				//do stuff here that handles mask cannot be saved
//			}
//		}
//	}
	
	
	var rawPhoto:CGImage?{
		willSet{
			capturedPhotoPreview = nil
		}
		didSet{
			if let img = rawPhoto{
				let visionAnalyser = VisionAnalyserModel()
				do{
					let visionCodes = try visionAnalyser.getQRCodesFromImage(img: img)
					let extractedCorners = try visionAnalyser.getCroppedBoundary(codeList: visionCodes)
					let croppedImage = try 
					visionAnalyser.correctPerspective(for: CIImage(cgImage: img),
									topLeft: extractedCorners.0,
									topRight: extractedCorners.1,
									bottomLeft: extractedCorners.2,
									bottomRight: extractedCorners.3)
					if let uimage = try visionAnalyser.completeImage(for: croppedImage!){
						capturedPhotoPreview = uimage
					}
				}catch{
					print(error)
				}
			}
		}
	}
	
	var sampleBuffer:CMSampleBuffer?{
		didSet{
			if let sample = sampleBuffer{
				DispatchQueue.main.async { [self] in
					do{
						let vn:[VNBarcodeObservation] = try visionAnalyser.QRCodesFromSample(sample: sample)
						let a = (checkCodeFound(search: "A", array: vn))
						let b = (checkCodeFound(search: "B", array: vn))
						let c = (checkCodeFound(search: "C", array: vn))
						let d = (checkCodeFound(search: "D", array: vn))
						qrPreviewState = QRDetection(A: a, B: b, C: c, D: d)
					}catch{
						print(error)
					}
				}
			}
		}
	}
	
	private func checkCodeFound(search:String, array:[VNBarcodeObservation]) -> Bool{
		if let _ = array.first(where: { $0.payloadStringValue == search }) {
			return true
		} else {
			return false
		}
	}
	
	func saveImageAndGetURL(image: UIImage, fileName: String) -> URL? {
		// Convert UIImage to Data
		guard let imageData = image.jpegData(compressionQuality: 1.0) else {
			return nil
		}
		// Get the document directory URL
		if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			// Append the file name to the document directory
			let fileURL = documentsDirectory.appendingPathComponent(fileName)
			do {
				// Write the data to the file
				try imageData.write(to: fileURL)
				return fileURL
			} catch {
				print("Error saving image: \(error)")
				return nil
			}
		}
		return nil
	}	
	
	func UIImageFromCVPixelBuffer(pixelBuffer: CVPixelBuffer) -> UIImage? {
		let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
		let context = CIContext(options: nil)
		if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
			return UIImage(cgImage: cgImage)
		} else {
			return nil
		}
	}
}
