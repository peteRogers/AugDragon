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
		
			List(cvm.savedMats) { item in
				MatEntryView(mat: item, cvm: cvm)
					.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
					.frame(height: 120)
					.listRowInsets(EdgeInsets())
					.padding(.top, 10)
					.background(Color.black)
			} //.background(Color.red)
			.scrollContentBackground(.hidden)
//			GeometryReader { proxy in
//				VStack{
//					ForEach(cvm.savedMats, id: \.id) { mat in
//						MatEntryView(mat: mat, cvm: cvm)
//						.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight:proxy.size.width/3)
//						.padding(.horizontal, 10)
//						.padding(.bottom, 10)
//					}
//				}
//			}
			
		}.frame(maxWidth: .infinity, alignment: .leading)
	}
}




			struct ItemView_Previews: PreviewProvider {
				static var previews: some View {
					//HomeView(cvm:CameraViewModel())
					HomeView(cvm: CameraViewModel())
				}
			}
