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
			VStack{
				switch cameraVM.viewState {
				case .showHome:
					HomeView(cvm: cameraVM)
				case .showMaskView:
					RealityView(cameraVM: cameraVM)
				case .showCamera:
					CameraView(cameraVM: cameraVM)
				case .showPhotoPreview:
					photoCheckView(cvm:cameraVM)
				case .showFacePaintView:
					FacePaintViewRepresentable(arDelegate: arDelegate)
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
