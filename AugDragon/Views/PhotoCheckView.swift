//
//  PhotoCheckView.swift
//  switUIEXPS
//
//  Created by Peter Rogers on 07/11/2023.
//

import Foundation
import SwiftUI

struct photoCheckView: View{
	@ObservedObject var cvm:CameraViewModel
	
	var body: some View{
		
		ZStack{
			VStack{
				Rectangle()
			}.frame(maxHeight: .infinity)
			.edgesIgnoringSafeArea(.all)
			VStack{
				ZStack{
					ProgressView()
					VStack{
						//Image(cvm.$capturedPhotoPreview)
						if let pic = cvm.capturedPhotoPreview{
							Image(uiImage: pic)
								.resizable() // Make the image resizable
								.aspectRatio(contentMode: .fit)
								.cornerRadius(30)
							Spacer()
						}
						
					}
					//					VStack{
					//						//resize view button (top Right)
					//						HStack{
					//							Spacer()
					//							Button(action: {
					//
					//								//cvm.takingPicture.toggle()
					//								// Action to perform when the button is tapped
					//							}) {
					//								Image(systemName: "arrow.up.left.and.arrow.down.right")
					//									.font(.system(size:40))
					//									.foregroundColor(.red)
					//									.background(Color.white.opacity(0.3))
					//									.cornerRadius(15)
					//							}.padding()
					//						}
					//						Spacer()
					//					}
				}
				Spacer()
				ButtonMenuView(cvm: cvm)
			}
		}
	}
}
