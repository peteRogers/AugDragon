//
//  HandlingJSON.swift
//  AugDragon
//
//  Created by Peter Rogers on 08/02/2024.
//

import Foundation

class HandlingJSON{
	
	func writeJSONData(_ totals: [Mat]) -> Void {
		do {
			let fileURL = try FileManager.default
				.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
				.appendingPathComponent("pastData.json")
			
			try JSONEncoder()
				.encode(totals)
				.write(to: fileURL)
		} catch {
			print("error writing data")
		}
	}
	
	
	func readData() -> [Mat] {
		do {
			let fileURL = try FileManager.default
				.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
				.appendingPathComponent("pastData.json")
			
			let data = try Data(contentsOf: fileURL)
			let pastData = try JSONDecoder().decode([Mat].self, from: data)
			
			return pastData
		} catch {
			print("error reading data")
			return []
		}
	}
}
