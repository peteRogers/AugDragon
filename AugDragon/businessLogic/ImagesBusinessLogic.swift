//
//  ImagesBusinessLogic.swift
//  AugDragon
//
//  Created by Peter Rogers on 22/01/2024.
//

import Foundation
import UIKit




class ImageBL{
	
	
	
	
	func saveImage(filename:String, img: UIImage) async throws -> URL?{
		guard let imageData = img.pngData() else {
			throw SavingError.imageDataError
		}
		if let u = await storeImageData(data: imageData, filename: filename){
			return u
		}
		return nil
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
