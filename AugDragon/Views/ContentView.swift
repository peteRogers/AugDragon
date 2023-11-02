//
//  ContentView.swift
//  animationsExp
//
//  Created by Peter Rogers on 13/09/2023.
//

import SwiftUI
import Vision

struct ContentView: View {
	@State var animationAmount = 1.0
	@State private var orientation = UIDeviceOrientation.unknown
	@StateObject var cameraVM = CameraViewModel()
	var body: some View {
		
		VStack() {
			//Text("Scanamat")
			GeometryReader { geometry in
				ZStack{
					
					CameraView{
						cameraVM.sampleBuffer = $0
						//print("\(geometry.size.width)")
					}
					
					.onRotate { newOrientation in
						orientation = newOrientation
						
					}
					ForEach(cameraVM.qrcode, id: \.self) { rect in
						ZStack{
							RoundedRectangle(cornerRadius: 15)
								.stroke(.blue, lineWidth: 10)
								.frame(width: geometry.size.width * (rect.boundingBox.height), height:
										geometry.size.width * (rect.boundingBox.height))
								.position(CGPoint(x: geometry.size.width * (rect.boundingBox.midY),
												  y: geometry.size.height * (rect.boundingBox.midX)))
							Text(rect.payloadStringValue ?? "")
								.frame(width: geometry.size.width * (rect.boundingBox.height), height:
										geometry.size.width * (rect.boundingBox.height))
								.position(CGPoint(x: geometry.size.width * (rect.boundingBox.midY),
												  y: geometry.size.height * (rect.boundingBox.midX)))
								.foregroundColor(.red)
						}
					}

						
					
				}
			}.padding(.horizontal)
			//Spacer()
			Button() {
				//animationAmount += 1
			}label: {
				Image(systemName: "qrcode.viewfinder")
					.imageScale(.large)
				
				
			}
			
			//			.rotationEffect(orientation == .landscapeLeft || orientation == .landscapeRight ? .degrees(90) : .degrees(0))
			//			.rotationEffect(orientation == .landscapeRight ? .degrees(-90) : .degrees(0))
			.animation(.default, value: orientation)
			.padding()
			.background(orientation == .landscapeLeft ? .red : .blue)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
			.overlay(
				RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
				
					.stroke(.red)
					.scaleEffect(animationAmount)
					.opacity(2 - animationAmount)
				
					.animation(
						.easeInOut(duration: 0.76)
						.repeatForever(autoreverses: false),
						value: animationAmount
					)
			)
			.onAppear {
				animationAmount = 2
			}
			Spacer()
		}
	}
}

//struct QRPosView: View{
//	
//	let geometry: GeometryProxy
//	let cameraVM: CameraViewModel
//	var body: some View {
//		
//		Rectangle()
//			.position(CGPoint(x: geometry.size.width * 0.5,
//							  y: geometry.size.height * 0.5))
//			.frame(width: 50, height: 50)
////		Path { path in
////			////			path.move(to: CGPoint(x: geometry.size.width * (cameraVM.rect?.minX ?? CGFloat(0)),
////			////								  y: geometry.size.height * (cameraVM.rect?.minY ?? CGFloat(0))))
////			////			path.move(to: CGPoint(x: geometry.size.width * (cameraVM.rect?.maxX ?? CGFloat(0)),
////			////								  y: geometry.size.height * (cameraVM.rect?.minY ?? CGFloat(0))))
////			////			path.move(to: CGPoint(x: geometry.size.width * (cameraVM.rect?.maxX ?? CGFloat(0)),
////			////								  y: geometry.size.height * (cameraVM.rect?.maxY ?? CGFloat(0))))
////			////			path.move(to: CGPoint(x: geometry.size.width * (cameraVM.rect?.minX ?? CGFloat(0)),
////			////								  y: geometry.size.height * (cameraVM.rect?.maxY ?? CGFloat(0))))
////			////
////			///
////			///
////			
////			path.move(to: CGPoint(x: geometry.size.width * (cameraVM.qrcode?.topLeft.y ?? CGFloat(0)),
////								  y: geometry.size.height * (cameraVM.qrcode?.topLeft.x ?? CGFloat(0))))
////			path.addLine(to: CGPoint(x: geometry.size.width * (cameraVM.qrcode?.topRight.y ?? CGFloat(0)),
////									 y: geometry.size.height * (cameraVM.qrcode?.topLeft.x ?? CGFloat(0))))
////			path.addLine(to: CGPoint(x: geometry.size.width * (cameraVM.qrcode?.bottomRight.y ?? CGFloat(0)),
////									 y: geometry.size.height * (cameraVM.qrcode?.bottomRight.x ?? CGFloat(0))))
////			path.addLine(to: CGPoint(x: geometry.size.width * (cameraVM.qrcode?.bottomLeft.y ?? CGFloat(0)),
////									 y: geometry.size.height * (cameraVM.qrcode?.bottomRight.x ?? CGFloat(0))))
////			
////			
////			path.closeSubpath()
////			
////			
////			//path.addLine(to: CGPoint(x: 300, y: 300))
////			//path.addLine(to: CGPoint(x: 200, y: 100))
////		}
////			.stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round))
////		
//	}
//}

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
