//
//  ButterflyViewController.swift
//  AugDragon
//
//  Created by Peter Rogers on 18/05/2024.
//

import Foundation
import RealityKit
import ARKit
import Combine

final class ButterflyViewController: UIViewController{
	var arView:ARView!
	var cameraLookAt:SIMD3<Float> = [0,2,0]
	var cameraLookFrom:SIMD3<Float> = [3,4,5]
	var baseEntity:Entity?
	var subscribes = Set<AnyCancellable>()
	let animator = ButterflyAnimator()
	weak var coordinator: ButterflyVIewControllerRepresentable.Coordinator?
	static let butterflyQuery = EntityQuery(where: .has(ButterflyMotionComponent.self))
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		DispatchQueue.main.async {
			self.createARView()
		}
	}
	
	func createARView(){
		
		animator.loadAnimations()
		arView = ARView(frame:.zero)
		
		arView.cameraMode = .nonAR
		arView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(arView)
		NSLayoutConstraint.activate([
			arView.topAnchor.constraint(equalTo: self.view.topAnchor),
			arView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			arView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			arView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
		let posCam = PerspectiveCamera()
		posCam.look(at: cameraLookAt, from: cameraLookFrom, relativeTo: nil)
		let cameraAnchor = AnchorEntity(world: .zero)
		cameraAnchor.addChild(posCam)
		arView.scene.addAnchor(cameraAnchor)
		self.arView.environment.background = .color(.lightGray)
		do{
			try self.createButterflyEntity()
		}catch{
			print(error)
		}
		
		arView.scene.subscribe(to: SceneEvents.Update.self) { event in
			self.updateFrame(deltaTime: event.deltaTime)
		}.store(in: &subscribes)
		
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//coordinator?.parent.showProgress = false
		print("reality view disappeared")
		baseEntity?.components.removeAll()
		subscribes.removeAll()
		arView.session.pause()
				 // there's no session on macOS
		arView.session.delegate = nil
		arView.scene.anchors.removeAll()
		arView.removeFromSuperview()
		arView.window?.resignKey()
		arView = nil
	}
	
	func createButterflyEntity() throws {
		do{
			
			
			baseEntity = try Entity.load(named: "bxFlying")
			if let be = baseEntity{
				let testAnchor = AnchorEntity(world: .zero)
			let image = UIImage(named: "butterflyWing.jpg")
			let cgImage = image?.cgImage
			let textureResource = try! TextureResource.generate(from: cgImage!, options: .init(semantic: .normal))
			var material = PhysicallyBasedMaterial()
			let baseColor = MaterialParameters.Texture(textureResource)
			material.baseColor = PhysicallyBasedMaterial.BaseColor(texture:baseColor)
			var modelComponent = baseEntity?.children[0].children[0].children[0].components[ModelComponent.self] as? ModelComponent
			print(modelComponent.debugDescription)
			modelComponent?.materials[0] = material
			baseEntity?.children[0].children[0].children[0].components.set(modelComponent!)
			baseEntity?.transform.scale = SIMD3(x: 0.3, y: 0.3, z: 0.3)
			baseEntity?.transform.translation.y += 8
			baseEntity?.position.y = 0
	
			
				let fc = ButterflyFlyingMotionControl(entity: be, arView: arView)
				let lc = ButterflyLandedMotionControl(entity: be, arView: arView)
				be.components.set(
					ButterflyMotionComponent(groundTarget: SIMD3(x: 0, y: 0, z: 0),
											 skyTarget: SIMD3(x: 4, y: 10, z: 0),
											 animator: animator,
											 state: .flyingUp,
											 flying: fc,
											 landing: lc
											 
											)
				)
				
			
				testAnchor.addChild(be)
				self.arView.scene.addAnchor(testAnchor)
				be.playAnimation(animator.getAnimationByName(name: "fly"), transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
			}
		}catch{
			
		}
	}
	
	func updateFrame(deltaTime: TimeInterval){
		arView.scene.performQuery(Self.butterflyQuery).forEach  { entity in
			if var mc:ButterflyMotionComponent = entity.components[ButterflyMotionComponent.self]{
				if(mc.state == .flyingUp){
					mc.flyingControl.updateUpPosition(deltaTime: deltaTime)
					//print("updating up")
				}
				if(mc.state == .flyingDown){
					mc.flyingControl.updateDownPosition(deltaTime: deltaTime)
					
				}
				if(mc.state == .takingOff){
					mc.flyingControl.doTakeOff()
				}
				if(mc.state == .landing){
					mc.landedControl.startLanded()
				}
				
				if(mc.state == .landed){
					//mc.landedControl.updatePosition(deltaTime: deltaTime)
							
					}
				}
//				if(mc.state == .landed){
//					mc.deinitFlyingControl()
//					if mc.landedControl != nil{
//
//						//mc.landedControl?.xoxo
//					}else{
//						mc.setLandedControl(entity: entity, arView: arView)
//						entity.components[MotionComponent.self] = mc
//					}
//
//				}
				
			
		}
	}
	
}
