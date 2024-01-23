//
//  ItemEntry.swift
//  AugDragon
//
//  Created by Peter Rogers on 20/12/2023.
//

import Foundation
import UIKit

struct ItemEntry: Codable, Identifiable {
	let title: String
	let imageURL: URL
	let date: Date
	let id: UUID
	
	
	
	static func preview() -> [ItemEntry] {
		return [ItemEntry(title: "Apple", imageURL: URL(string:"www.bbc.com")!, date: Date.now, id: UUID())
				
		]
	}
}

struct QRDetection{
	let A:Bool
	let B:Bool
	let C:Bool
	let D:Bool
}


struct Mat: Codable, Identifiable{
	let id: UUID
	private (set) var imgSettings: ImgSettings?
	var linkToImage: URL?
	let type: String
	let date: Date
	
	init(image:UIImage, type:String ) async throws{
		self.id = UUID()
		self.date = Date.now
		self.type = type
		do{
			if let url = try await saveImage(filename: self.id.uuidString, img: image){
				self.linkToImage =  url
			}
		}catch{
			throw SavingError.matUnableToBeCreatedError
		}
	}
	
	mutating func changeImageSettings(settings: ImgSettings){
		imgSettings	= settings
	}
	
	func saveImage(filename:String, img: UIImage) async throws  -> URL?{
		guard let imageData = img.pngData() else {
			throw SavingError.imageDataError
		}
		guard let u = await storeImageData(data: imageData, filename: filename) else{
			throw SavingError.urlNotCreated
		}
		return u
	}
	
	func storeImageData(data:Data, filename: String ) async -> URL?{
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

struct ImgSettings: Codable{
	private (set) var brightness: Double
	mutating func changeBrightness(level:Double){
		self.brightness = level
	}
}


