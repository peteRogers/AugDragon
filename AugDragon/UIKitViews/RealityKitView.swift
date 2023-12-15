//
//  RealityKitView.swift
//  AugDragon
//
//  Created by Peter Rogers on 21/11/2023.
//

import SwiftUI
import RealityKit
import ARKit

struct RealityKitView: UIViewRepresentable {
	@ObservedObject var model: CameraViewModel
	
	func makeUIView(context: Context) -> ARView {
		let arView = ARView(frame: .zero,
						cameraMode: .nonAR,
						automaticallyConfigureSession: false)
		
		let camera = PerspectiveCamera()
		camera.camera.fieldOfViewInDegrees = 60
		
		let cameraAnchor = AnchorEntity(world: .zero)
		cameraAnchor.addChild(camera)
		arView.scene.addAnchor(cameraAnchor)
		
		loadCatMask(arView: arView)
		
		return arView
	}
	
	func loadCatMask(arView:ARView){
		do{
		let catMask = try Entity.loadModel(named: "catFace.usdz")
			
		   // fatalError("not loading")
			let dragonAnchor = AnchorEntity(world: .zero)
			arView.scene.addAnchor(dragonAnchor)
			catMask.transform.scale *= 0.05
			dragonAnchor.addChild(catMask)
		   // dragon.transform.rotation = simd_quatf(angle: Float(deg2rad(180)), axis:simd_make_float3(1,0, 0))
			catMask.transform.translation = simd_make_float3(0,
															 -2.5,
															-20)
			
			guard let cgImage = model.capturedPhotoPreview?.cgImage else {
				fatalError("Failed to create CGImage from UIImage")
			}
			let textureResource = try! TextureResource.generate(from: cgImage, options: .init(semantic: .normal))
			
			var material = SimpleMaterial()
			//material.color.texture = .init(try! .load(named: "catMaskLayoutV2.png", in: nil))
			material.color = .init(texture: .init(textureResource))
//			//catMask.materials[0] = material
			catMask.model!.materials[0] = material
		
		}catch{
			
		}
	}
	func updateUIView(_ uiView: ARView, context: Context) {
		//updateCounter(uiView: uiView)
	}
	

}

