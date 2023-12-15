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
					photoCheckView(cvm:cameraVM)
				}
				if(cameraVM.showARView){
					RealityView(cameraVM: cameraVM)
					
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

struct HomeView: View{
	@ObservedObject var cvm:CameraViewModel
	var body: some View{
		VStack{
			Button(action: {
				cvm.home = false
				cvm.showPhotoPreview = true
				//cvm.takingPicture.toggle()
				// Action to perform when the button is tapped
			}) {
				Image(systemName: "arrow.up.left.and.arrow.down.right")
					.font(.system(size:40))
					.foregroundColor(.red)
					.background(Color.white.opacity(0.3))
					.cornerRadius(15)
			}.padding()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
