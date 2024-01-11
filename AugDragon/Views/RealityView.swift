//
//  RealityView.swift
//  AugDragon
//
//  Created by Peter Rogers on 14/12/2023.
//

import Foundation


import SwiftUI

struct RealityView: View{
	@ObservedObject var cameraVM:CameraViewModel
	var body: some View{
		ZStack{
			
			RealityKitLiveView(model: cameraVM)
			VStack{
				HStack{
					
					Button(action: {
						// Action to perform when the button is tapped
						//cameraVM.callTakePhotoFunctionInUIKIT()
						withAnimation{
							cameraVM.showARView = false
							cameraVM.showCamera = false
							cameraVM.showPhotoPreview = true
						}
						
					}) {
						Image(systemName: "arrowshape.turn.up.backward")
							.font(.system(size: 50))
							.foregroundColor(.red)
						
						
					}
					Spacer()
				}
				Spacer()
			}
			
		}
		
	}
}
	
