//
//  RealityKitLiveView.swift
//  AugDragon
//
//  Created by Peter Rogers on 18/12/2023.
//


import SwiftUI
import RealityKit
import ARKit

struct RealityKitLiveView: UIViewRepresentable {
	@ObservedObject var model: CameraViewModel
	
	
	func makeUIView(context: Context) -> ARView {
		let arView = ARView(frame: .zero)
		
		let directionalLight = DirectionalLight()
		directionalLight.light.color = .white
		directionalLight.light.intensity = 5000
		directionalLight.light.isRealWorldProxy = true
		directionalLight.shadow?.maximumDistance = 10.0
		directionalLight.shadow?.depthBias = 5.0
		directionalLight.orientation = simd_quatf(angle: -.pi/1.5,axis: [0,1,0])
		let lightAnchor = AnchorEntity(world: [0,0,-3])
		lightAnchor.addChild(directionalLight)
		arView.scene.addAnchor(lightAnchor)
		//loadCatMask(arView: arView)
		print("before task")
		Task {
				await makeCall(arView: arView)
			
			}
		
		print("arview returning")
		//model.showProgress = false
		return arView
	}
	
	func makeCall(arView:ARView) async{
		do{
			guard let cgImage = model.capturedPhotoPreview?.cgImage else {
				fatalError("Failed to create CGImage from UIImage")
			}
			let mask = try await makeCatMask(cgImage:cgImage)
			let anchor = AnchorEntity(.face)
			anchor.addChild(mask)
			arView.scene.anchors.append(anchor)
			arView.session.run(ARFaceTrackingConfiguration())
		}catch{
			
		}
		print("task completed")
		
	}
	
	func makeCatMask(cgImage:CGImage)async throws -> Entity{
		do{
			let catMask = try Entity.loadModel(named: "catFace.usdz")
			catMask.transform.scale *= 0.001
			catMask.transform.translation = simd_make_float3(0,0,0)
			let textureResource = try! TextureResource.generate(from: cgImage, options: .init(semantic: .normal))
			var material = PhysicallyBasedMaterial()
			let baseColor = MaterialParameters.Texture(textureResource)
			material.baseColor = PhysicallyBasedMaterial.BaseColor(texture:baseColor)
			let emissiveColor = MaterialParameters.Texture(textureResource)
			material.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(texture:emissiveColor)
			material.emissiveIntensity = 0.5
			catMask.model!.materials[0] = material
			return catMask
		}catch{
			throw RealityError.modelLoadingError
		}
	}

	func loadCatMask(arView:ARView) throws{
		do{
		let catMask = try Entity.loadModel(named: "catFace.usdz")
			let anchor = AnchorEntity(.face)
			anchor.addChild(catMask)
			arView.scene.anchors.append(anchor)
			catMask.transform.scale *= 0.001
			catMask.transform.translation = simd_make_float3(0,0,0)
			guard let cgImage = model.capturedPhotoPreview?.cgImage else {
				fatalError("Failed to create CGImage from UIImage")
			}
			let textureResource = try! TextureResource.generate(from: cgImage, options: .init(semantic: .normal))
			var material = PhysicallyBasedMaterial()
			let baseColor = MaterialParameters.Texture(textureResource)
			material.baseColor = PhysicallyBasedMaterial.BaseColor(texture:baseColor)
			let emissiveColor = MaterialParameters.Texture(textureResource)
			material.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(texture:emissiveColor)
			material.emissiveIntensity = 0.5
			catMask.model!.materials[0] = material
		
		}catch{
			
		}
	}
	func updateUIView(_ uiView: ARView, context: Context) {
		//updateCounter(uiView: uiView)
	
	}
	

}


