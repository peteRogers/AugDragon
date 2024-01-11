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
			List{
				GeometryReader { geometry in
					ItemView(item: ItemEntry(title: "test", imageURL: URL(string: "foof")!, date: Date.now, id: UUID())).frame(minHeight: geometry.size.height)
				}.listRowInsets(EdgeInsets())
				
			}
			
//			Button(action: {
//				cvm.home = false
//				cvm.showPhotoPreview = true
//			}) {
//				Image(systemName: "arrow.up.left.and.arrow.down.right")
//					.font(.system(size:40))
//					.foregroundColor(.red)
//					.background(Color.white.opacity(0.3))
//					.cornerRadius(15)
//			}.padding()
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
					TView()
				}
			}
