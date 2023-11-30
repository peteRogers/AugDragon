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
				return img
			}catch{
				
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
	
	
	func correctPerspective(for ciImage: CIImage, topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) throws -> UIImage? {
		//print("\(topLeft) \(topRight) \(bottomLeft) \(bottomRight)")
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
		let outputImage = filter?.outputImage
		
		// Convert the CIImage to a UIImage
		let context = CIContext()
		if let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent) {
			
			let outputUIImage = UIImage(cgImage: cgImage)
			return outputUIImage
			// Now, outputUIImage contains the greyscale version of your image
		}
		return UIImage(named:"cat.png")!
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
