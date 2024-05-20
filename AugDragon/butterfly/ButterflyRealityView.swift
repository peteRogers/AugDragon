//
//  ButterflyRealityView.swift
//  AugDragon
//
//  Created by Peter Rogers on 18/05/2024.
//

import Foundation
import SwiftUI

struct ButterflyRealityView: View{
	var cameraVM:CameraViewModel
	var body: some View{
	VStack{
		ButterflyVIewControllerRepresentable(mat: cameraVM.currentMat!, showProgress: cameraVM.showProgress)
		}
	}
}
	
