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
	
	@Published var qrcode:[VNBarcodeObservation] = []
	//@Published var drawingDetected = false // 4 qrcodes counted
	@Published var takingPicture = false
	@Published var capturedPhotoPreview:UIImage?
	
	var takePhotoCaller: (() -> Void)?
	
	
	func callTakePhotoFunctionInUIKIT() {
		takePhotoCaller?()
	}
	
	var rawPhoto:CGImage?{
		didSet{
			if let img = rawPhoto{
				capturedPhotoPreview = UIImage(cgImage: img, scale: 1.0, orientation: .right)
				}
			}
	}
	
	
	
	
	var sampleBuffer:CMSampleBuffer?{
		didSet{
			
			if let sample = sampleBuffer{
				do{
					let vn:[VNBarcodeObservation] = try visionAnalyser.analyseQRCodes(sample: sample)
					DispatchQueue.main.async { [self] in
					if(vn.count > 0){
							//self.qrcode = vn[0]
						//print(sample.formatDescription)
						
						self.qrcode = vn
						if(vn.count == 4){
							print("from taking photo")
							//self.drawingDetected = true
							
							//self.callTakePhotoFunctionInUIKIT()
						}else{
							//self.drawingDetected = false
						}
					}else{
						self.qrcode = []
					}
						
					}
				}catch{
						print(error)
				}
			}
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
