//
//  ItemEntry.swift
//  AugDragon
//
//  Created by Peter Rogers on 20/12/2023.
//

import Foundation
import UIKit



struct QRDetection{
	let A:Bool
	let B:Bool
	let C:Bool
	let D:Bool
}

struct ImageStore{
	let id: String
	let image: UIImage
	var isSaved = false
	
}


struct Mat: Codable, Identifiable{
	let id: UUID
	private (set) var imgSettings: ImgSettings?
	var linkToImage: URL?
	var matTemplate: MatTemplate?
	var date: Date = Date.now
	private (set) var matID: String?
	
	
	init() {
		self.id = UUID()
		
	}
	
	func getID()->String{
		return id.uuidString
	}
	
	mutating func saveImageToDisk(image: UIImage) async throws{
		do{
			if let url = try await saveImage(filename: self.id.uuidString, img: image){
				self.linkToImage =  url
			}
		}catch{
			throw SavingError.matUnableToBeCreatedError
		}
	}
	
	mutating func setMatTemplate(_matTemplate: MatTemplate ){
		matTemplate =  _matTemplate
	}
	
	mutating func changeImageSettings(settings: ImgSettings){
		imgSettings	= settings
	}
	
	private func saveImage(filename:String, img: UIImage) async throws  -> URL?{
		guard let imageData = img.pngData() else {
			throw SavingError.imageDataError
		}
		guard let u = await storeImageData(data: imageData, filename: filename) else{
			throw SavingError.urlNotCreated
		}
		return u
	}
	
	private func storeImageData(data:Data, filename: String ) async -> URL?{
		do{
			let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(filename).png")
			try data.write(to: url)
			return url
		}catch{
			print(SavingError.noSavePNG)
			return nil
		}
	}
}

struct MatTemplate:  Codable{
	let matID: String
	var matType: MatType = .catMask
}

struct ImgSettings: Codable{
	private (set) var brightness: Double
	mutating func changeBrightness(level:Double){
		self.brightness = level
	}
}


