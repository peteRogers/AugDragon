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
					ForEach(cvm.savedMats, id: \.id) { mat in
						MatEntryView(mat: mat, cvm: cvm)
						.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight:proxy.size.width/3)
						.padding(.horizontal, 10)
						.padding(.bottom, 10)
					}
				}
			}
			Spacer()
			ButtonMenuView(cvm: cvm)
		}
	}
}




			struct ItemView_Previews: PreviewProvider {
				static var previews: some View {
					//HomeView(cvm:CameraViewModel())
					HomeView(cvm: CameraViewModel())
				}
			}
