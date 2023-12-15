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
			VStack{
				Rectangle()
			}.frame(maxHeight: .infinity)
			 .edgesIgnoringSafeArea(.all)
			VStack{
				CameraViewRepresentable(model: cameraVM){
					cameraVM.sampleBuffer = $0
				}
			}
			
			VStack{
				Spacer()
				Spacer()
				HStack{
					Spacer()
					Spacer()
					if(cameraVM.A == true){
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.red)
							.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
					}else{
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.gray)
							.opacity(0.4)
					}
					Spacer()
					if(cameraVM.B == true){
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.red)
							.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
					}else{
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.gray)
							.opacity(0.4)
					}
					Spacer()
					Spacer()
					
				}.padding(.top)
				//Spacer()
				HStack{
					Spacer()
					Spacer()
					if(cameraVM.C == true){
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.red)
							.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
					}else{
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.gray)
							.opacity(0.4)
					}
					Spacer()
					if(cameraVM.D == true){
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.red)
							.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
					}else{
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 50))
							.foregroundColor(.gray)
							.opacity(0.4)
					}
					Spacer()
					Spacer()
					
				}.padding(.top, 100)
				Spacer()
				Spacer()
			}
			
			
			
//			.overlay(){
//				GeometryReader { geometry in
//					ForEach(cameraVM.qrcode, id: \.self) { qrcode in
//						let myY = mapper(x: qrcode.boundingBox.midX,
//										 in_min: 0.0 ,
//										 in_max: 1.0,
//										 out_min:geometry.frame(in: .global).minY,
//										 out_max: geometry.frame(in: .global).height)
//						RoundedRectangle(cornerRadius: 1)
//							.stroke(.blue, lineWidth: 1)
//							.frame(width: geometry.size.width * (qrcode.boundingBox.height),
//								   height:geometry.size.width * (qrcode.boundingBox.height))
//							.position(CGPoint(x: geometry.size.width * (qrcode.boundingBox.midY),
//											  y: myY - (geometry.size.width * (qrcode.boundingBox.height)/2)))
//					}
//				}
//			}
			VStack{
				Spacer()
				Button(action: {
					// Action to perform when the button is tapped
					cameraVM.callTakePhotoFunctionInUIKIT()
					withAnimation{
						cameraVM.showCamera = false
						cameraVM.showPhotoPreview = true
					}
					
				}) {
					Image(systemName: "record.circle")
						.font(.system(size: 100))
						.foregroundColor(.red)
					
					
				}
			}
			
		}
	}
//	func mapper( x: CGFloat, in_min:CGFloat ,in_max:CGFloat, out_min:CGFloat, out_max:CGFloat)->CGFloat
//	{
//		return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
//	}
}
