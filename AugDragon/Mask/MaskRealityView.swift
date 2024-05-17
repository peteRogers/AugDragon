//
//  RealityView.swift
//  AugDragon
//
//  Created by Peter Rogers on 14/12/2023.
//

import Foundation
import SwiftUI

struct MaskRealityView: View{
	var cameraVM:CameraViewModel
	var body: some View{
	VStack{
			RealityKitLiveViewRepresentable(mat: cameraVM.currentMat!, showProgress: cameraVM.showProgress)
		}
	}
}
	
