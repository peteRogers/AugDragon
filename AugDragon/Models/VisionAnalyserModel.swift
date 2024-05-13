//
//  VisionAnalyserModel.swift
//  AugDragon
//
//  Created by Peter Rogers on 02/11/2023.
//



import Foundation
import Vision
import CoreImage
import UIKit

class VisionAnalyserModel{
	func QRCodesFromSample(sample:CMSampleBuffer) throws -> [VNBarcodeObservation]{
		let barcodeRequest = VNDetectBarcodesRequest()
		barcodeRequest.symbologies = [.qr]
		let imageHandler = VNImageRequestHandler(cmSampleBuffer: sample)
		try imageHandler.perform([barcodeRequest])
		if let results = barcodeRequest.results {
			return results
		}
		throw QRCodeError.noneFound
	}
	
	func getQRCodesFromImage(img: CGImage) throws -> [VNBarcodeObservation]{
		let barcodeRequest = VNDetectBarcodesRequest()
		barcodeRequest.symbologies = [.qr]
		let imageHandler = VNImageRequestHandler(cgImage: img)
		try imageHandler.perform([barcodeRequest])
		if let results = barcodeRequest.results {
			return results
		}
		throw QRCodeError.noneFound
	}
	
	func getCroppedBoundary(codeList: [VNBarcodeObservation])throws -> (CGPoint, CGPoint, CGPoint, CGPoint){
		guard let codeA = getQRFromSearch(search: "A", array: codeList) else {
			throw QRCodeError.unableToCropQRMissing
		}
		guard let codeB = getQRFromSearch(search: "B", array: codeList) else {
			throw QRCodeError.unableToCropQRMissing
		}
		guard let codeC = getQRFromSearch(search: "C", array: codeList) else {
			throw QRCodeError.unableToCropQRMissing
		}
		guard let codeD = getQRFromSearch(search: "D", array: codeList) else {
			throw QRCodeError.unableToCropQRMissing
		}
		return (CGPoint(x:codeA.boundingBox.midX, y:codeA.boundingBox.midY),
				CGPoint(x:codeB.boundingBox.midX, y:codeB.boundingBox.midY),
				CGPoint(x:codeC.boundingBox.midX, y:codeC.boundingBox.midY),
				CGPoint(x:codeD.boundingBox.midX, y:codeD.boundingBox.midY))
	}
	
	func getQRFromSearch(search:String, array:[VNBarcodeObservation])-> VNBarcodeObservation?{
		if let matchedObservation = array.first(where: { $0.payloadStringValue == search }) {
			return matchedObservation
		}
		return nil
	}
	
	func correctPerspective(for ciImage: CIImage, topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) throws -> CIImage? {
		
		let inputBottomLeft = CIVector(x: bottomLeft.x * ciImage.extent.width,
									   y: bottomLeft.y * ciImage.extent.height)
		let inputTopLeft = CIVector(x: topLeft.x * ciImage.extent.width,
									y: topLeft.y * ciImage.extent.height)
		let inputTopRight = CIVector(x: topRight.x * ciImage.extent.width,
									 y: topRight.y * ciImage.extent.height)
		let inputBottomRight = CIVector(x: bottomRight.x * ciImage.extent.width,
										y: bottomRight.y * ciImage.extent.height)
		let filter = CIFilter(name: "CIPerspectiveCorrection")
		filter?.setValue(inputTopLeft, forKey: "inputTopLeft")
		filter?.setValue(inputTopRight, forKey: "inputTopRight")
		filter?.setValue(inputBottomLeft, forKey: "inputBottomLeft")
		filter?.setValue(inputBottomRight, forKey: "inputBottomRight")
		filter?.setValue(ciImage, forKey: "inputImage")
		if let outputImage = filter?.outputImage{
			return outputImage
		}else{
			throw CIFilterError.transformFailure
		}
	}
	
	func filterVibrancy(for ciImage: CIImage)throws -> CIImage?{
		let vibrance = CIFilter(name:"CIVibrance")
		
		// Set the vibrance value (range: -1.0 to 1.0)
		
		vibrance?.setValue(ciImage, forKey: kCIInputImageKey)
		vibrance?.setValue(-1, forKey: kCIInputAmountKey)
		if let outputImage = vibrance?.outputImage{
			return outputImage
		}else{
			throw CIFilterError.vibrancyError
		}
	}
	
	func filterWhiteBalnce(for ciImage: CIImage)throws -> CIImage?{
		// Create a filter instance (CITemperatureAndTint)
		let temperature: CGFloat = 4000 // Adjust the temperature value as needed
		let tint: CGFloat = 2// Adjust the tint value as needed
		let temperatureAndTintFilter = CIFilter(name: "CITemperatureAndTint")
		
		// Set the input image
		temperatureAndTintFilter?.setValue(ciImage, forKey: kCIInputImageKey)
		
		// Set the temperature and tint values
		temperatureAndTintFilter?.setValue(CIVector(x: temperature, y: tint), forKey: "inputNeutral")
		return temperatureAndTintFilter?.outputImage
	}
	
	
	func filterSaturation(for ciImage: CIImage)throws -> CIImage?{
		
		let filter = CIFilter(name: "CIColorControls")
		
		// Set the input image
		filter?.setValue(ciImage, forKey: kCIInputImageKey)
		
		// Set saturation to 0 to create a black and white effect
		filter?.setValue(2, forKey: kCIInputSaturationKey)
		return filter?.outputImage
	}
	
	func completeImage(for ciImage: CIImage) throws -> UIImage? {
		let context = CIContext()
		if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
			let outputUIImage = UIImage(cgImage: cgImage)
			return outputUIImage
			// Now, outputUIImage contains the greyscale version of your image
		}else{
			throw CIFilterError.errorCompleting
		}
	}
}



