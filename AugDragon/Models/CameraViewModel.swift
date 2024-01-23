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
	@Published var savedMats:[Mat] = []
	var takePhotoCaller: (() -> Void)?
	@Published var showProgress = false
	var currentMat:Mat?
	
	func callTakePhotoFunctionInUIKIT() {
		takePhotoCaller?()
		self.viewState = .showPhotoPreview
	}

	init(){
		print("started init")
		
		Task{
			do{
				let img = UIImage(named: "catMaskLayoutV2.png")
				let m1 = try await Mat(image: img!, type: "Sample1")
				savedMats.append(m1)
				let m2 = try await Mat(image: img!, type: "Sample2")
				savedMats.append(m2)
			}catch{
				
			}
		}
	}
	
	
	func openMat(mat:Mat){
		currentMat = mat
		viewState = .showMaskView
	}
	
	
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
