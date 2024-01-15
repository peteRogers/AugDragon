//
//  HomeView.swift
//  AugDragon
//
//  Created by Peter Rogers on 20/12/2023.
//

import Foundation
import SwiftUI

struct HomeView: View{
	@ObservedObject var cvm:CameraViewModel
	var body: some View{
		VStack{
			Text("Saved Mats")
				.font(.largeTitle)
				.padding(.top)
				.foregroundColor(.lighttext)
		
				
			GeometryReader { proxy in
				VStack{

					MaskEntry(cvm: cvm)
					.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight:proxy.size.width/3)
					.padding(.horizontal, 10)
					.padding(.bottom, 10)
					
					MaskEntry(cvm: cvm)
					.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight:proxy.size.width/3)
					.padding(.horizontal, 10)
					.padding(.bottom, 10)
					
					
					
				}
			}
			
			ButtonMenuView(cvm: cvm)
		}
	}
}

struct TView: View{
	let items = ["Item 1", "Item 2", "Item 3", "Item 4"]

	var body: some View {
		VStack{
			ScrollView {
				ForEach(items, id: \.self) { item in
					
//						HStack{
//													RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
//														.frame(width: geometry.size.height)
					ItemView(item: ItemEntry(title: "test", imageURL: URL(string: "foof")!, date: Date.now, id: UUID()))
						.frame(height: 120)
						
						
							
						
						
					
						
						.listRowBackground(Color.pink)
					
					
				}
			}.padding()
			
			
			
		}
	}
	
}


			struct ItemView_Previews: PreviewProvider {
				static var previews: some View {
					//HomeView(cvm:CameraViewModel())
					HomeView(cvm: CameraViewModel())
				}
			}
