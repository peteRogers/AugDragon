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
			CameraViewRepresentable(model: cameraVM){
				cameraVM.sampleBuffer = $0
			}
			
			.overlay(){
				GeometryReader { geometry in
					ForEach(cameraVM.qrcode, id: \.self) { qrcode in
						let myY = mapper(x: qrcode.boundingBox.midX,
										 in_min: 0.0 ,
										 in_max: 1.0,
										 out_min:geometry.frame(in: .global).minY,
										 out_max: geometry.frame(in: .global).height)
						RoundedRectangle(cornerRadius: 1)
							.stroke(.blue, lineWidth: 1)
							.frame(width: geometry.size.width * (qrcode.boundingBox.height),
								   height:geometry.size.width * (qrcode.boundingBox.height))
							.position(CGPoint(x: geometry.size.width * (qrcode.boundingBox.midY),
											  y: myY - (geometry.size.width * (qrcode.boundingBox.height)/2)))
					}
				}
			}
			VStack{
				Spacer()
				Button(action: {
					// Action to perform when the button is tapped
					cameraVM.callTakePhotoFunctionInUIKIT()
					withAnimation{
						cameraVM.takingPicture = false
					}
					
				}) {
					Image(systemName: "record.circle")
						.font(.system(size: 100))
						.foregroundColor(.red)
					
					
				}.padding(50)
			}
			
		}
	}
	func mapper( x: CGFloat, in_min:CGFloat ,in_max:CGFloat, out_min:CGFloat, out_max:CGFloat)->CGFloat
	{
		return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
	}
}
