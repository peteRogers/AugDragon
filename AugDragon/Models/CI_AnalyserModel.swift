//
//  CI_AnalyserModel.swift
//  AugDragon
//
//  Created by Peter Rogers on 21/11/2023.
//

import Foundation
import UIKit
import Vision


class CI_AnalyserModel{
//	var vc:ViewController!
//
//	func setVC(vc:ViewController){
//		self.vc = vc;
//	}
//
	func analyseImage(cImage: CIImage)throws -> UIImage {
		do{
			let qrs = try getQRLocations(for: cImage)
			var featureA, featureB, featureC, featureD:CIFeature!
			if let f = qrs.compactMap({ $0 as? CIQRCodeFeature }).first(where: { $0.messageString == "A" }) {
				featureA = f
			}else{
				throw QRCodeError.notAllFound
			}
			if let f = qrs.compactMap({ $0 as? CIQRCodeFeature }).first(where: { $0.messageString == "B" }) {
				featureB = f
			}else{
				throw QRCodeError.notAllFound
			}
			if let f = qrs.compactMap({ $0 as? CIQRCodeFeature }).first(where: { $0.messageString == "C" }) {
				featureC = f
			}else{
				throw QRCodeError.notAllFound
			}
			if let f = qrs.compactMap({ $0 as? CIQRCodeFeature }).first(where: { $0.messageString == "D" }) {
				featureD = f
			}else{
				throw QRCodeError.notAllFound
			}
			do{
				
				print("got codes")
				let img = try correctPerspective(for: cImage,
												 topLeft: CGPoint(x: featureA.bounds.midX, y: featureA.bounds.midY),
												 topRight: CGPoint(x: featureB.bounds.midX, y: featureB.bounds.midY),
												 bottomLeft: CGPoint(x: featureC.bounds.midX, y: featureC.bounds.midY),
												 bottomRight: CGPoint(x: featureD.bounds.midX, y: featureD.bounds.midY))!
				
				print("from trying to return")
				
				let wbIm = try filterWhiteBalnce(for: img)
				let vibIm = try filterSaturation(for: wbIm!)
				let outim = try completeImage(for: vibIm!)
				return outim!
			}catch{
				print(error)
			}
		}
		catch QRCodeError.noneFound{
			print("no codes found")
		}
		catch QRCodeError.notAllFound{
			print("not all codes found")
		}
		catch{
			print("something else")
		}
		return UIImage(named: "catFace.jpg")!
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
	
	func filterSaturation(for ciImage: CIImage)throws -> CIImage?{
	
	let filter = CIFilter(name: "CIColorControls")
	
	// Set the input image
	filter?.setValue(ciImage, forKey: kCIInputImageKey)
	
	// Set saturation to 0 to create a black and white effect
	filter?.setValue(2, forKey: kCIInputSaturationKey)
	return filter?.outputImage
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
	
	
	func correctPerspective(for ciImage: CIImage, topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) throws -> CIImage? {
		let inputBottomLeft = CIVector(x: bottomLeft.x, y: bottomLeft.y)
		let inputTopLeft = CIVector(x: topLeft.x, y: topLeft.y)
		let inputTopRight = CIVector(x: topRight.x, y: topRight.y)
		let inputBottomRight = CIVector(x: bottomRight.x, y: bottomRight.y)
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
		
//		let whiteBalanceFilter = CIFilter(name: "CITemperatureAndTint")
//		whiteBalanceFilter?.setValue(outputImage, forKey: kCIInputImageKey)
//
//		// Set the desired temperature and tint values
//		let temperature = 5000.0 // Adjust this value as needed
//		let tint = 0.0 // Adjust this value as needed
//
//		whiteBalanceFilter?.setValue(CIVector(x: temperature, y: tint), forKey: "inputNeutral")
		// Convert the CIImage to a UIImage

//		let context = CIContext()
//		if let cgImage = context.createCGImage((vibrance?.outputImage)!, from: outputImage!.extent) {
//	//	if let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent) {
//
//			let outputUIImage = UIImage(cgImage: cgImage)
//			return outputUIImage
//			// Now, outputUIImage contains the greyscale version of your image
//		}
//		return UIImage(named:"cat.png")!
	}

	func getQRLocations(for ciImage: CIImage) throws -> [CIFeature]{
		let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
		let features = detector.features(in: ciImage)
		if(features.isEmpty){
			throw QRCodeError.noneFound
		}
		if(features.count < 4){
			throw QRCodeError.notAllFound
		}
		return features
		
	}
	
	
}

enum QRCodeError: Error {
	case noneFound
	case notAllFound
	case perspectiveError
}

enum CIFilterError: Error {
	case errorCompleting
	case transformFailure
	case vibrancyError
}

enum SavingError: Error {
	case noSaveJPG
}
