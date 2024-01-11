//
//  ItemEntry.swift
//  AugDragon
//
//  Created by Peter Rogers on 20/12/2023.
//

import Foundation

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
