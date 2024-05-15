//
//  File.swift
//  AugDragon
//
//  Created by Peter Rogers on 08/11/2023.
//

import Foundation

import SwiftUI

struct CameraView: View{
	var cameraVM:CameraViewModel
	var body: some View{
		
		ZStack{
			GeometryReader{ geo in
				VStack{
					Rectangle()
				}.frame(maxHeight: .infinity)
					.edgesIgnoringSafeArea(.all)
					.foregroundColor(.specA)
				VStack{
					Spacer()
					CameraViewRepresentable(model: cameraVM){
						cameraVM.sampleBuffer = $0
					}.frame(height: geo.size.height * 0.70)
						.padding(.top, 20)
					

					Spacer()
				}
			}
			VStack{
				Spacer()
				QRPreviewView(cameraVM: cameraVM)
				Spacer()
				
			}
		}
	}
}



struct QRPreviewView : View{
	var cameraVM:CameraViewModel
	var body: some View{
		VStack{
			Spacer()
			
			HStack{
				Spacer()
				Spacer()
				if(cameraVM.qrPreviewState?.A == true){
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.specAccent)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.specD)
						.opacity(0.4)
				}
				Spacer()
				if(cameraVM.qrPreviewState?.B == true){
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.specAccent)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.specD)
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
						.foregroundColor(.specAccent)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.specD)
						.opacity(0.4)
				}
				Spacer()
				if(cameraVM.qrPreviewState?.D == true){
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.specAccent)
						.opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
				}else{
					Image(systemName: "qrcode.viewfinder")
						.font(.system(size: 50))
						.foregroundColor(.specD)
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
