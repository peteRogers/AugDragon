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
	@StateObject var cameraVM = CameraViewModel()
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
					RealityView(cameraVM: cameraVM)
						.onDisappear(perform: {
							
						})
				case .showCamera:
					CameraView(cameraVM: cameraVM)
				case .showPhotoPreview:
					photoCheckView(cvm:cameraVM)
				case .showFacePaintView:
					FacePaintViewRepresentable(arDelegate: arDelegate)
				case .showInstructions:
					InstructionsView(cvm:cameraVM)
				case .showLoading:
					Rectangle()
				case .showPhotoSettings:
					photoCheckView(cvm:cameraVM)
					
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
