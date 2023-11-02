//
//  CameraViewModel.swift
//  animationsExp
//
//  Created by Peter Rogers on 15/09/2023.
//

import Foundation
import AVFoundation
import Vision

@MainActor class CameraViewModel: ObservableObject{
	
	let visionAnalyser = VisionAnalyser()
	@Published var qrcode:[VNBarcodeObservation] = []
	
	var sampleBuffer:CMSampleBuffer?{
		didSet{
			if let sample = sampleBuffer{
				do{
					let vn:[VNBarcodeObservation] = try visionAnalyser.analyseQRCodes(sample: sample)
					DispatchQueue.main.async {
					if(vn.count > 0){
							//self.qrcode = vn[0]
						self.qrcode = vn
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
}
