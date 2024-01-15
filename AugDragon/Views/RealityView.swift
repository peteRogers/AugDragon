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
		VStack{
			RealityKitLiveView(model: cameraVM)
			ButtonMenuView(cvm: cameraVM)
			
		}
		
		
	}
}
	
