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
	@Published var showCamera = false
	@Published var showPhotoPreview = false
	@Published var home = true
	@Published var showARView = false
	@Published var capturedPhotoPreview:UIImage?
	@Published var A = true
	@Published var B = false
	@Published var C = false
	@Published var D = false
	
	
	var takePhotoCaller: (() -> Void)?
	
	
	func callTakePhotoFunctionInUIKIT() {
		takePhotoCaller?()
	}
	
	var rawPhoto:CGImage?{
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
//							if(vn.count > 0){
//								
//								//print(vn[0].payloadStringValue)
//							}
//							self.A = false
//							if((checkCodeFound(search: "A", array: vn))){
//								self.A = true
//							}
						self.A = (checkCodeFound(search: "A", array: vn))
						self.B = (checkCodeFound(search: "B", array: vn))
						self.C = (checkCodeFound(search: "C", array: vn))
						self.D = (checkCodeFound(search: "D", array: vn))
						}catch{
							print(error)
						}
					}
//					DispatchQueue.main.async { [self] in
//						if(vn.count > 0){
//							//self.qrcode = vn[0]
//							//	print(sample.formatDescription)
//							
//							//self.qrcode = vn
//							if(vn.count == 4){
//								//	print("from taking photo")
//								//self.drawingDetected = true
//								
//								//self.callTakePhotoFunctionInUIKIT()
//							}else{
//								//self.drawingDetected = false
//							}
//						}else{
//							//self.qrcode = []
//						}
//						
//					}
				
			}
		}
	}
	
	private func checkCodeFound(search:String, array:[VNBarcodeObservation]) -> Bool{
		if let matchedObservation = array.first(where: { $0.payloadStringValue == search }) {
			// matchedObservation contains the first VNBarcodeObservation where payloadString matches 'x'
			//print(matchedObservation)
			return true
		} else {
			// No match found
			//print("No match found")
			return false
		}
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
