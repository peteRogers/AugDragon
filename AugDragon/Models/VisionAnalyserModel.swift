//
//  VisionAnalyserModel.swift
//  AugDragon
//
//  Created by Peter Rogers on 02/11/2023.
//



import Foundation
import Vision

class VisionAnalyserModel{
	private let sequenceHandler = VNSequenceRequestHandler()
	private let videoDataOutputQueue = DispatchQueue(
		label: "CameraFeedOutput",
		qos: .userInteractive
	)
	
	func analyseQRCodes(sample:CMSampleBuffer) throws -> [VNBarcodeObservation]{
		guard let frame = CMSampleBufferGetImageBuffer(sample) else {
			debugPrint("unable to get image from sample buffer")
			throw QrCodeError.badSample
		}
		let barcodeRequest = VNDetectBarcodesRequest()
		barcodeRequest.symbologies = [.qr]
		try? self.sequenceHandler.perform([barcodeRequest], on: frame, orientation: .up)
		if let results = barcodeRequest.results {
			return results
		}
		throw QrCodeError.badbad
	}
}
