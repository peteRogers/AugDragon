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
	@StateObject private var model = GameControllerModel()
	var body: some View{
		ZStack{
			VStack{
				ButterflyVIewControllerRepresentable(mat: cameraVM.currentMat!, gameController: model, showProgress: cameraVM.showProgress)
			}
			GameControllerView(model: model)
		}
	}
}
	
