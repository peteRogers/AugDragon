import SwiftUI
import RealityKit

struct RealityKitLiveViewRepresentable: UIViewControllerRepresentable {
	var mat: Mat
	func makeCoordinator() -> Coordinator {
		//	class Coordinator: NSObject{
		return Coordinator(self, mat: mat)
		//	}
	}
	
	
	class Coordinator: NSObject{
		var parent: RealityKitLiveViewRepresentable
		var mat: Mat
		
		init(_ parent: RealityKitLiveViewRepresentable, mat: Mat) {
			self.mat = mat
			self.parent = parent
		}
	}
	
	func makeUIViewController(context: Context) -> RealityViewController {
		let viewController = RealityViewController()
		return viewController
	}

	func updateUIViewController(_ uiViewController: RealityViewController, context: Context) {
		// Update the ARView if needed
	}
}








////
////  RealityKitLiveView.swift
////  AugDragon
////
////  Created by Peter Rogers on 18/12/2023.
////
//
//
//import SwiftUI
//import RealityKit
//import ARKit
//import UIKit
//
//struct RealityKitLiveView: UIViewRepresentable {
//	@ObservedObject var model: CameraViewModel
//	
//	
//	
//	class Coordinator: NSObject{
//		var parent: RealityKitLiveView
//		var otherViewLoaded = false
//		var arView: ARView?
//
//		init(_ parent: RealityKitLiveView) {
//			self.parent = parent
//		}
//	}
//	
//	func makeCoordinator() -> Coordinator {
//		Coordinator(self)
//	}
//	func makeUIView(context: Context) -> UIView {
//		
//		let view = UIView()
//			   view.backgroundColor = .blue
//			   return view
//		
//
//	}
//	
//	
//	
//	func makeCall(arView:ARView) async{
//		if let url = model.currentMat?.linkToImage{
//			do{
//				let imageData = try Data(contentsOf: url)
//				let image = UIImage(data: imageData)
//				guard let cgImage = image?.cgImage else {
//					fatalError("Failed to create CGImage from UIImage")
//				}
//				let mask = try await makeCatMask(cgImage:cgImage)
//				let anchor = AnchorEntity(.face)
//				anchor.addChild(mask)
//				arView.scene.anchors.append(anchor)
//				arView.session.run(ARFaceTrackingConfiguration())
//				
//			}catch{
//				
//			}
//		}
//	}
//	
//	func makeCatMask(cgImage:CGImage)async throws -> Entity{
//		do{
//			let catMask = try Entity.loadModel(named: "catFace.usdz")
//			catMask.transform.scale *= 0.001
//			catMask.transform.translation = simd_make_float3(0,0,0)
//			let textureResource = try! TextureResource.generate(from: cgImage, options: .init(semantic: .normal))
//			var material = PhysicallyBasedMaterial()
//			let baseColor = MaterialParameters.Texture(textureResource)
//			material.baseColor = PhysicallyBasedMaterial.BaseColor(texture:baseColor)
//			let emissiveColor = MaterialParameters.Texture(textureResource)
//			material.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(texture:emissiveColor)
//			material.emissiveIntensity = 0.5
//			catMask.model!.materials[0] = material
//			return catMask
//		}catch{
//			throw RealityError.modelLoadingError
//		}
//	}
//	
//	static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
//		  // uiView.session.pause()
//	   }
//	
//	
//func updateUIView(_ uiView: UIView, context: Context) {
//		//updateCounter(uiView: uiView)
//	print("from updated view")
//	print(uiView.frame)
//	if(context.coordinator.arView != nil){
//		context.coordinator.arView?.frame = uiView.frame
//	}
//	if context.coordinator.otherViewLoaded == false {
//		context.coordinator.otherViewLoaded = true
//		DispatchQueue.main.async {
//			// Perform any heavy task here in background
//			// Create the UIView without modifying its UI properties
//			context.coordinator.arView = ARView(frame: uiView.frame)
//					let directionalLight = DirectionalLight()
//					directionalLight.light.color = .white
//					directionalLight.light.intensity = 5000
//					directionalLight.light.isRealWorldProxy = true
//					directionalLight.shadow?.maximumDistance = 10.0
//					directionalLight.shadow?.depthBias = 5.0
//					directionalLight.orientation = simd_quatf(angle: -.pi/1.5,axis: [0,1,0])
//					let lightAnchor = AnchorEntity(world: [0,0,-3])
//					lightAnchor.addChild(directionalLight)
//					context.coordinator.arView!.scene.addAnchor(lightAnchor)
//					Task {
//						await makeCall(arView: context.coordinator.arView!)
//						if let _ = context.coordinator.arView{
//							// Add the view to your view hierarchy
//							
//						
//							context.coordinator.arView!.translatesAutoresizingMaskIntoConstraints = false
//								   NSLayoutConstraint.activate([
//									context.coordinator.arView!.topAnchor.constraint(equalTo: uiView.topAnchor),
//									context.coordinator.arView!.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
//									context.coordinator.arView!.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
//									context.coordinator.arView!.trailingAnchor.constraint(equalTo: uiView.trailingAnchor)
//								   ])
//							uiView.addSubview(context.coordinator.arView!)
//						}
//			
//						}
//					
//			
//			// Switch back to the main thread to update the UI
//			
//				// Now you can safely modify UI properties
//				//arView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//				//newView.backgroundColor = UIColor.red
//				
//			
//		}
//	}
//
//	}
//	
//	
//	
//	
//}
