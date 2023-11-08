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
	var vc:ViewController!
	func setVC(vc: ViewController){
		self.vc = vc
	}
	
	func analyseImage(cImage: CIImage)throws -> UIImage {
		do{
			let qrs = try getQRLocations(for: cImage)
			var featureA, featureB, featureC, featureD:CIFeature!
			if let f = qrs.compactMap({ $0 as? CIQRCodeFeature }).first(where: { $0.messageString == "A" }) {
				featureA = f
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
				let img = try correctPerspective(for: cImage,
												 topLeft: CGPoint(x: featureA.bounds.midX, y: featureA.bounds.midY),
												 topRight: CGPoint(x: featureB.bounds.midX, y: featureB.bounds.midY),
												 bottomLeft: CGPoint(x: featureC.bounds.midX, y: featureC.bounds.midY),
												 bottomRight: CGPoint(x: featureD.bounds.midX, y: featureD.bounds.midY))!
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
		return UIImage(named: "IMG_0957.png")!
	}
	
	
	func correctPerspective(for ciImage: CIImage, topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) throws -> UIImage? {
		//let h = ciImage.extent.height
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
		if let ciOutput = filter?.outputImage{
			return UIImage(ciImage: ciOutput)
		}else{
			throw QRCodeError.perspectiveError
		}
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
//		var qrCodeLink = ""
//		for feature in features as? [CIQRCodeFeature] ?? [] {
//			qrCodeLink += (feature.messageString ?? "") + "\n"
//		}
		return features
		
	}
}

enum QRCodeError: Error {
	case noneFound
	case notAllFound
	case perspectiveError
}
