//
//  RealityViewController.swift
//  AugDragon
//
//  Created by Peter Rogers on 23/01/2024.
//

import Foundation
import UIKit
import RealityKit
import ARKit


final class RealityViewController: UIViewController{
	
	var arView:ARView!
	weak var coordinator: RealityKitLiveViewRepresentable.Coordinator?
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		DispatchQueue.main.async {
			self.createARView()
		}
	}
	
	func createARView(){
		arView = ARView(frame:.zero)
		arView.session.run(ARFaceTrackingConfiguration())
		arView.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(arView)
		arView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			arView.topAnchor.constraint(equalTo: self.view.topAnchor),
			arView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			arView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			arView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
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
		Task {
			await makeCall(arView: arView)
			
			self.view.addSubview(arView)
			coordinator?.parent.showProgress = false
		}
	}
	
	func makeCatMask(cgImage:CGImage) throws -> Entity{
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
	
	func makeCall(arView:ARView) async{
		if let url = coordinator?.mat.linkToImage{
			do{
				let imageData = try Data(contentsOf: url)
				let image = UIImage(data: imageData)
				guard let cgImage = image?.cgImage else {
					fatalError("Failed to create CGImage from UIImage")
				}
				let mask = try makeCatMask(cgImage:cgImage)
				let anchor = AnchorEntity(.face)
				anchor.addChild(mask)
				arView.scene.anchors.append(anchor)
				
				
			}catch{
				
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		super.viewWillDisappear(animated)
		coordinator?.parent.showProgress = false
		print("reality view disappeared")
		arView.session.pause()
		         // there's no session on macOS
		arView.session.delegate = nil
		arView.scene.anchors.removeAll()
		arView.removeFromSuperview()
		arView.window?.resignKey()
		arView = nil
	}
	
}
