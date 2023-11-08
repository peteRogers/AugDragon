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
		VStack{
			Spacer()
			if (cameraVM.takingPicture == true){
				CameraView(cameraVM: cameraVM)
					//.transition(AnyTransition.opacity.combined(with: .slide))
			}else{
				photoCheckView(cvm:cameraVM)
					.transition(AnyTransition.opacity.combined(with: .slide))
			}
		}
	}
}

struct DeviceRotationViewModifier: ViewModifier {
	let action: (UIDeviceOrientation) -> Void
	func body(content: Content) -> some View {
		content
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
