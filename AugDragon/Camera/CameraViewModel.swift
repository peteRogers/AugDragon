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

@Observable class CameraViewModel{
	
	@ObservationIgnored let visionAnalyser = VisionAnalyserModel()
	@ObservationIgnored private var imageStore:[ImageStore] = []
	var viewState:ViewState?
	var capturedPhotoPreview:UIImage?
	var qrPreviewState:QRDetection?
	var savedMats:[Mat] = []
	var takePhotoCaller: (() -> Void)?
	var showProgress = false
	@ObservationIgnored var currentMat:Mat?
	@ObservationIgnored var presaveMat:Mat?
	
	func callTakePhotoFunctionInUIKIT() {
		takePhotoCaller?()
		
		self.showPhotoPreview()
		
	}

	init(){
		DispatchQueue.main.async {
			self.showHome()
		}
		//MARK: creating sample mats
		
	
		if let img = UIImage(named: "catMaskLayoutV2.png"){
					self.makeSampleMat(matID: "1", img: img)
					print(img.size)
		}
		
		if let img = UIImage(named: "facePaintGraphic.jpg"){
			self.makeSampleMat(matID: "2", img: img)
		}
		
		if let img = UIImage(named: "butterflyWing.jpg"){
			self.makeSampleMat(matID: "3", img: img)
		}
//		if let img = UIImage(named: "catMaskLayoutV2.png"){
//			self.makeSampleMat(matID: "1", img: img)
//		}
				
				
			
		
	}
	
	
	
	
	func openMat(mat:Mat){
		currentMat = mat
		DispatchQueue.main.async { [self] in
			if(currentMat?.matTemplate?.matID == "2"){
				viewState = .showFacePaintView
			}
			if(currentMat?.matTemplate?.matID == "1"){
				viewState = .showMaskView
			}
			if(currentMat?.matTemplate?.matID == "3"){
				viewState = .showButterflyView
			}
		}
	}
	
	
	@ObservationIgnored var rawPhoto:CGImage?{
		willSet{
			capturedPhotoPreview = nil
			presaveMat = nil
		}
		didSet{
			if let img = rawPhoto{
				
				let visionAnalyser = VisionAnalyserModel()
				do{
					
					let visionCodes = try visionAnalyser.getQRCodesFromImage(img: img)
					var matID = "none found"
					if(visionCodes.count > 0){
						if let qrString = visionCodes[0].payloadStringValue{
							matID = try visionAnalyser.getIDFromQR(qrSting: qrString)
						}
					}
					let extractedCorners = try visionAnalyser.getCroppedBoundary(codeList: visionCodes)
					let croppedImage = try 
					visionAnalyser.correctPerspective(for: CIImage(cgImage: img),
									topLeft: extractedCorners.0,
									topRight: extractedCorners.1,
									bottomLeft: extractedCorners.2,
									bottomRight: extractedCorners.3)
					
					if let uimage = try visionAnalyser.completeImage(for: croppedImage!){
					
						capturedPhotoPreview = uimage
						makePremat(matID: matID)
					}
					
				}catch{
					print(error)
					capturedPhotoPreview = UIImage(cgImage: img)
				}
			}
		}
	}
	
	func makePremat(matID:String){
		if let cp = capturedPhotoPreview{
			presaveMat = Mat()
			if let id = presaveMat?.getID(){
				let store = ImageStore(id: id, image: cp, isSaved: false)
				imageStore.append(store)
				presaveMat?.setMatTemplate(_matTemplate: MatTemplate(matID: matID))
			}
		}
	}
	
	func makeSampleMat(matID: String, img: UIImage){
		Task{
		var mat = Mat()
		let store = ImageStore(id: mat.getID(), image: img, isSaved: true)
		imageStore.append(store)
		mat.setMatTemplate(_matTemplate: MatTemplate(matID: matID))
		
			
			do{
				try await mat.saveImageToDisk(image: img)
				savedMats.append(mat)
				
				
			}
		}
		
	}
	
	
	func saveMat(){
		if let pm = presaveMat{
			if var foundStruct = imageStore.first(where: { $0.id == pm.getID() }) {
				let img = foundStruct.image
				foundStruct.isSaved = true
				imageStore.append(foundStruct)
				imageStore.removeAll(where: { !$0.isSaved})
				Task{
					var matToSave = pm
					do{
						try await matToSave.saveImageToDisk(image: img)
						savedMats.append(matToSave)
						currentMat = matToSave
						DispatchQueue.main.async {
							self.showHome()
						}
					}
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
						var a = false
						if visionAnalyser.getQRFromSearch(search: "A", array: vn) != nil{
							a = true
						}
						var b = false
						if visionAnalyser.getQRFromSearch(search: "B", array: vn) != nil{
							b = true
						}
						var c = false
						if visionAnalyser.getQRFromSearch(search: "C", array: vn) != nil{
							c = true
						}
						var d = false
						if visionAnalyser.getQRFromSearch(search: "D", array: vn) != nil{
							d = true
						}
						qrPreviewState = QRDetection(A: a, B: b, C: c, D: d)
					}catch{
						print(error)
					}
				}
			}
		}
	}
	
	func showCamera(){
		showProgress = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
			self.viewState = .showCamera
		}
		
	}
	
	func showInstructions(){
		viewState = .showInstructions
	}
	
	func showHome(){
		self.viewState = .showHome
		self.showProgress = false
	}
	
	func showPhotoSettings(){
		viewState = .showPhotoSettings
	}
	
	func hideLoadingView(_:Bool){
	
	}
	
	func showPhotoPreview(){
		viewState = .showPhotoPreview
	}
	
	func showProgressView(_show:Bool){
		showProgress = _show
	}
	
	func showMaskView(){
		viewState = .showMaskView
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
