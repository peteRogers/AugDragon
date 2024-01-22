//
//  ItemView.swift
//  AugDragon
//
//  Created by Peter Rogers on 20/12/2023.
//

import Foundation
import SwiftUI



struct ItemView: View{
	let item:ItemEntry
	var body: some View {
		GeometryReader { proxy in
			ZStack {
				RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
				HStack{
					RoundedRectangle(cornerRadius: 20)
						.frame(width: .infinity)
						.aspectRatio(1, contentMode: .fit)
						.foregroundColor(.red)
						.padding(.leading,10)
						.padding(.vertical,10)
						.padding(.trailing, 0)
					VStack{
						Text("My title")
							.fontDesign(.rounded)
							.fontWeight(.semibold)
							
							.frame( maxWidth: .infinity, alignment: .leading)
							
							.foregroundColor(.white)
						Text("tersting")
							.fontDesign(.rounded)
							.fontWeight(.thin)
							.foregroundColor(.white)
							.frame( maxWidth: .infinity, alignment: .leading)
						
							
						Spacer()
					}.frame(maxWidth: .infinity)
						.padding(.leading, 5)
						.padding(.trailing, 10)
						.padding(.top, 10)
					//Spacer()
				}
			}
		}
	}
}

struct ItemViewtView_Previews: PreviewProvider {
	static var previews: some View {
		ItemView(item: ItemEntry(title: "fokfoef", imageURL: URL(string: "foof")!, date: Date.now, id: UUID()))
	}
}
