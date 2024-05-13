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
				.foregroundColor(.specE)
		
			List(cvm.savedMats) { item in
				MatEntryView(mat: item, cvm: cvm)
					.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
					.frame(height: 120)
					.listRowInsets(EdgeInsets())
					.padding(.top, 15)
					.background(.specA)
			} //.background(Color.red)
			.scrollContentBackground(.hidden)
			
		}.frame(maxWidth: .infinity, alignment: .leading)
	}
}




			struct ItemView_Previews: PreviewProvider {
				static var previews: some View {
					//HomeView(cvm:CameraViewModel())
					HomeView(cvm: CameraViewModel())
				}
			}
