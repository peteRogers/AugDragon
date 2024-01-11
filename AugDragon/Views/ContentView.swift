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
	var body: some View {
		ZStack{
			VStack{
				Rectangle()
				}.frame(maxHeight: .infinity)
				.edgesIgnoringSafeArea(.all)
			VStack{
				if(cameraVM.home){
					HomeView(cvm: cameraVM)
				}
				if(cameraVM.showCamera){
					//Spacer()
					CameraView(cameraVM: cameraVM)
				}
				if(cameraVM.showPhotoPreview){
					Spacer()
					ZStack{
						ProgressView()
							.frame(width: 300, height: 300)
							.scaleEffect(5.0)
							.tint(.white)
						photoCheckView(cvm:cameraVM)
					}
				}
				if(cameraVM.showARView){
					ZStack{
						ProgressView()
							.frame(width: 300, height: 300)
							.scaleEffect(5.0)
							.tint(.white)
						RealityView(cameraVM: cameraVM)
					}
				}
			}

		}
	}
}

struct DeviceRotationViewModifier: ViewModifier {
	let action: (UIDeviceOrientation) -> Void
	func body(content: Content) -> some View {content
		.onAppear()
		.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
			action(UIDevice.current.orientation)
		}
	}
}

extension View {
	func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
		self.modifier(DeviceRotationViewModifier(action: action))
	}
}



struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
