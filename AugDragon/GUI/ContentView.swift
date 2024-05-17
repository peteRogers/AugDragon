//
//  ContentView.swift
//  animationsExp
//
//  Created by Peter Rogers on 13/09/2023.
//

import SwiftUI
import Vision

struct ContentView: View {
	@State private var orientation = UIDeviceOrientation.unknown
	var cameraVM = CameraViewModel()
	@ObservedObject var arDelegate = FacePaintModel()
	var body: some View {
		ZStack{
			VStack{
				Rectangle()
				}.frame(maxHeight: .infinity)
				.edgesIgnoringSafeArea(.all)
				.foregroundColor(.specA)
				
			VStack{
				switch cameraVM.viewState {
				case .showHome:
					HomeView(cvm: cameraVM)
				case .showMaskView:
					MaskRealityView(cameraVM: cameraVM)
						.onDisappear(perform: {
							cameraVM.showProgressView(_show: false)
						})
				case .showCamera:
					CameraView(cameraVM: cameraVM)
				case .showPhotoPreview:
					photoCheckView(cvm:cameraVM)
				case .showFacePaintView:
					FacePaintViewRepresentable(arDelegate: arDelegate, mat: cameraVM.currentMat!)
				case .showInstructions:
					InstructionsView(cvm:cameraVM)
				case .showPhotoSettings:
					photoCheckView(cvm:cameraVM)
					
				case .none:
					HomeView(cvm: cameraVM)
				}
				Spacer()
				ButtonMenuView(cvm: cameraVM)
			}
			
			if(cameraVM.showProgress == true){
				ActivityView()
			}
		}
	}
}



struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
