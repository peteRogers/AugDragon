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
	
	//@Published var qrcode:[VNBarcodeObservation] = []
	//@Published var drawingDetected = false // 4 qrcodes counted
	@Published var showCamera = true
	@Published var showPhotoPreview = false
	@Published var home = false
	@Published var showARView = false
	@Published var capturedPhotoPreview:UIImage?
	@Published var A = false
	@Published var B = false
	@Published var C = false
	@Published var D = false
	@Published var savedArray:[ItemEntry] = []
	var takePhotoCaller: (() -> Void)?
	
	func callTakePhotoFunctionInUIKIT() {
		takePhotoCaller?()
		self.showCamera = false
		self.showPhotoPreview = true
	}
	
	func tryToSaveMask(){
		do{
			try saveMask()
		}catch{
			print(error)
			//do stuff here that handles mask cannot be saved
		}
	}
	
	func saveMask() throws{
		if let cpp = capturedPhotoPreview{
			guard let imageData = cpp.jpegData(compressionQuality: 1.0) else {
				throw SavingError.noSaveJPG
			}
			// Get the document directory URL
			if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
				// Append the file name to the document directory
				let fileURL = documentsDirectory.appendingPathComponent("save as date")
				do {
					// Write the data to the file
					try imageData.write(to: fileURL)
					let m = ItemEntry(title: "tititititle", imageURL: fileURL, date: Date.now, id: UUID())
					//let m = ItemEntry(title: "tititititle", imageURL: fileURL, date: Date.now, id: UUID())
					savedArray.append(m)
					savedArray.append(m)
				} catch {
					print("Error saving image: \(error)")
					throw SavingError.noSaveJPG
				}
			}
		}
	}
	
	var rawPhoto:CGImage?{
		willSet{
			print("from will set")
		}
		didSet{
			if let img = rawPhoto{
				capturedPhotoPreview = UIImage(cgImage: img, scale: 1.0, orientation: .right)
				let ci = CI_AnalyserModel()
				do{
					//print("w: \(img.width) h: \(img.height)")
					let im = try ci.analyseImage(cImage: CIImage(cgImage: img))
					capturedPhotoPreview = im
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
						let vn:[VNBarcodeObservation] = try visionAnalyser.analyseQRCodes(sample: sample)
						self.A = (checkCodeFound(search: "A", array: vn))
						self.B = (checkCodeFound(search: "B", array: vn))
						self.C = (checkCodeFound(search: "C", array: vn))
						self.D = (checkCodeFound(search: "D", array: vn))
					}catch{
						print(error)
					}
				}
			}
		}
	}
	
	private func checkCodeFound(search:String, array:[VNBarcodeObservation]) -> Bool{
		if let matchedObservation = array.first(where: { $0.payloadStringValue == search }) {
			// matchedObservation contains the first VNBarcodeObservation where payloadString matches 'x'
			//print(matchedObservation)
			print(matchedObservation.debugDescription)
			return true
		} else {
			// No match found
			//print("No match found")
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
