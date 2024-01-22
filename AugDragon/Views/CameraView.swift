//
//  File.swift
//  AugDragon
//
//  Created by Peter Rogers on 08/11/2023.
//

import Foundation

import SwiftUI

struct CameraView: View{
	@ObservedObject var cameraVM:CameraViewModel
	var body: some View{
		
		ZStack{
			GeometryReader{ geo in
				VStack{
					Rectangle()
				}.frame(maxHeight: .infinity)
					.edgesIgnoringSafeArea(.all)
				VStack{
					//Rectangle().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
					
					CameraViewRepresentable(model: cameraVM){
						cameraVM.sampleBuffer = $0
					}.frame(height: geo.size.height * 0.70)
					 .padding(.top, 20)
					
					Button(action: {
						// Action to perform when the button is tapped
						cameraVM.showProgress = true
						cameraVM.callTakePhotoFunctionInUIKIT()
						
						
						
					}) {
						Image(systemName: "record.circle")
							.font(.system(size: geo.size.height * 0.1))
							.foregroundColor(.itembackgrounds)
							
						
						
					}.padding(.top,0)
					Spacer()
					ButtonMenuView(cvm: cameraVM)
						
				}
					
					
					
				}
				
				
				VStack{
					Spacer()
					
				}
			}
		}
	}
//	func mapper( x: CGFloat, in_min:CGFloat ,in_max:CGFloat, out_min:CGFloat, out_max:CGFloat)->CGFloat
//	{
//		return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
//	}



struct QRPreviewView : View{
	@ObservedObject var cameraVM:CameraViewModel
	var body: some View{
		VStack{
			Spacer()
			
			HStack{
				Spacer()
				Spacer()
				if(cameraVM.qrPreviewState?.A == true){
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.itembackgrounds)
						.opacity(0.4)
				}
				Spacer()
				if(cameraVM.qrPreviewState?.B == true){
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.itembackgrounds)
						.opacity(0.4)
				}
				Spacer()
				Spacer()
				
			}.padding(.top)
			Spacer()
			HStack{
				Spacer()
				Spacer()
				if(cameraVM.qrPreviewState?.C == true){
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.itembackgrounds)
						.opacity(0.4)
				}
				Spacer()
				if(cameraVM.qrPreviewState?.D == true){
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.itembackgrounds)
						.opacity(0.4)
				}
				Spacer()
				Spacer()
				
			}.padding(.top, 20)
			Spacer()
			Spacer()
		}
		
	}
}
