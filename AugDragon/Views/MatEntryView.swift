//
//  ItemView.swift
//  AugDragon
//
//  Created by Peter Rogers on 20/12/2023.
//

import Foundation
import SwiftUI

struct MatEntryView: View{
	
	let s = "gorjgojg rjgo rgojrg oj groj gro groj gro. cr r r vrk vrkv rkv r rrngornv rvonrvomov rvorm"
	var body: some View {
		GeometryReader { proxy in
			ZStack {
				RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
				HStack{
					RoundedRectangle(cornerRadius: 20)
						.frame(minWidth: 0.0, maxWidth: .infinity)
						.aspectRatio(1, contentMode: .fit)
						.foregroundColor(.itembackgrounds)
						.padding(.leading,10)
						.padding(.vertical,10)
						.padding(.trailing, 0)
					VStack{
						Text("My title")
							.fontDesign(.rounded)
							.fontWeight(.bold)
							
							.frame( maxWidth: .infinity, alignment: .leading)
							
							.foregroundColor(.lighttext)
						Text(s)
							.fontDesign(.rounded)
							.fontWeight(.regular)
							.foregroundColor(.lighttext)
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


//
//struct ItemViewtView_Previews: PreviewProvider {
//	static var previews: some View {
//		ItemView(item: ItemEntry(title: "fokfoef", imageURL: URL(string: "foof")!, date: Date.now, id: UUID()))
//	}
//}
