//
//  ItemView.swift
//  AugDragon
//
//  Created by Peter Rogers on 20/12/2023.
//

import Foundation
import SwiftUI

struct MatEntryView: View{
	let mat:Mat
	let cvm:CameraViewModel
	
	var body: some View {
		GeometryReader { proxy in
			ZStack {
				RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
					.foregroundColor(.specB)
					
				HStack{
					//RoundedRectangle(cornerRadius: 20)
					Button {
						//DispatchQueue.main.async {
						cvm.showProgressView(_show: true)
							
						//}
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							cvm.openMat(mat: mat)
							cvm.showProgressView(_show: false)
						}
					} label: {
						AsyncImage(url: mat.linkToImage)
						{ phase in
							switch phase {
							case .empty:
								ZStack {
									Color.gray
									ProgressView()
								}
							case .success(let image):
								image.resizable()
							case .failure(let error):
								Text(error.localizedDescription)
								// use placeholder for production app
							@unknown default:
								EmptyView()
							}
						}.frame(minWidth: 0.0,  //maxWidth:proxy.size.height * 0.9,
								maxHeight:proxy.size.height * 0.9)
						.aspectRatio(1, contentMode: .fit)
						.cornerRadius(20)
						.padding(.leading, 5)
					}
					VStack{
						Text(mat.matTemplate?.matType.rawValue ?? "Mat not Assigned")
							.fontDesign(.rounded)
							.fontWeight(.bold)							
							.frame( maxWidth: .infinity, alignment: .leading)
							.foregroundColor(.specE)
						Text(mat.matTemplate?.matID ?? "nil")
							.fontDesign(.rounded)
							.fontWeight(.regular)
							.foregroundColor(.specE)
							.frame( maxWidth: .infinity, alignment: .leading)
						Spacer()
					}.frame(maxWidth: .infinity)
						.padding(.leading, 5)
						.padding(.trailing, 10)
						.padding(.top, 10)
				}
			}
		}.padding(0)
	}
}


//
//struct ItemViewtView_Previews: PreviewProvider {
//	static var previews: some View {
//		ItemView(item: ItemEntry(title: "fokfoef", imageURL: URL(string: "foof")!, date: Date.now, id: UUID()))
//	}
//}
