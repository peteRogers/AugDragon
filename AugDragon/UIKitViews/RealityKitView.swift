//
//  RealityKitView.swift
//  AugDragon
//
//  Created by Peter Rogers on 21/11/2023.
//

import SwiftUI
import RealityKit

struct RealityKitView: UIViewRepresentable {
	
	
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
//			var material = SimpleMaterial()
//			material.color.texture = .init(try! .load(named: "catFace.jpg", in: nil))
//			//catMask.materials[0] = material
//			catMask.model!.materials[0] = material
		
		}catch{
			
		}
	}
	func updateUIView(_ uiView: ARView, context: Context) {
		//updateCounter(uiView: uiView)
	}
	
//	private func updateCounter(uiView: ARView) {
//		uiView.scene.anchors.removeAll()
//		
//		let anchor = AnchorEntity()
//		let text = MeshResource.generateText(
//			"\(abs(count.num))",
//			extrusionDepth: 0.08,
//			font: .systemFont(ofSize: 0.5, weight: .bold)
//		)
//		
//		let color: UIColor
//		
//		switch count.num {
//		case let x where x < 0:
//			color = .red
//		case let x where x > 0:
//			color = .green
//		default:
//			color = .white
//		}
//
//		let shader = SimpleMaterial(color: color, roughness: 4, isMetallic: true)
//		let textEntity = ModelEntity(mesh: text, materials: [shader])
//
//		textEntity.position.z -= 1.5
//		textEntity.setParent(anchor)
//		uiView.scene.addAnchor(anchor)
//	}
}

