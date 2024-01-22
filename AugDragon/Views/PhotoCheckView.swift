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
					//ProgressView()
					VStack{
						if let pic = cvm.capturedPhotoPreview{
							Image(uiImage: pic)
								.resizable() // Make the image resizable
								.aspectRatio(contentMode: .fit)
								.cornerRadius(30)
								.onAppear(){
									cvm.showProgress = false
								}
							Spacer()
						}
						
					}
				}
				Spacer()
				ButtonMenuView(cvm: cvm)
			}
		}
	}
}
