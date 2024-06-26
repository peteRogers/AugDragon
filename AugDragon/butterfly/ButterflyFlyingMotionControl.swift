//
//
//  FlyingAnimationControl.swift
//  Butterfly_SwiftUI
//
//  Created by student on 07/03/2024.
//

import Foundation
import RealityKit
import ARKit
import Combine
import simd

class ButterflyFlyingMotionControl{
    
    //var downVector:Float = 0
    weak var entity: Entity?
    var subscriptions = Set<AnyCancellable>()
	weak var arView:ARView?
	
	var speed:Float = 3.0
	var direction:Float = 0.0
    var isFlying = false
	var upAccel:Float = 0.001
	var rot:Float = 0.001
	
    init(entity: Entity, arView: ARView){
        self.entity = entity
        self.arView = arView
    }
	
	deinit {
		print("flying deinit")
		subscriptions.removeAll()
	}
	
	func killMe(){
		print("killed flying")
		subscriptions.removeAll()
	}
	
	
	func updateDownPosition(deltaTime: TimeInterval){
		if var mc:ButterflyMotionComponent = entity?.components[ButterflyMotionComponent.self]{
			do{
				let r = try updateTowardsRotation(deltaTime: Float(deltaTime), target: mc.groundTarget)
				entity?.transform.rotation *= r
				if let pos = entity?.position{
					let mp = moveTowards(targetPosition: mc.groundTarget, from: pos, speed: speed, deltaTime: deltaTime)
					
					if(mc.groundTarget == pos){
						print("met ground target:")
						mc.setState(state: .landing)
						entity?.components[ButterflyMotionComponent.self] = mc
					}
					entity?.position = mp
				}
			}catch{
				print( error)
			}
		}
	}
	
	
	private func updateRotation(deltaTime: Float, target: SIMD3<Float>) throws -> simd_quatf {
		let rotSpeed:Float = 1
		if let entityTransform = entity?.transformMatrix(relativeTo: nil){
			
			// Calculate current direction and target direction
			let currentPosition = SIMD3<Float>(entityTransform.columns.3.x, entityTransform.columns.3.y, entityTransform.columns.3.z)
			let directionToTarget = normalize(target - currentPosition)
			let currentForward = normalize(SIMD3<Float>(entityTransform.columns.2.x, 0, entityTransform.columns.2.z))
			
			// Calculate angle to target in radians
			let angleToTarget = atan2(directionToTarget.x, directionToTarget.z) - atan2(currentForward.x, currentForward.z)
			
			// Determine the amount to rotate this frame
			let maxRotationThisFrame = rotSpeed * deltaTime
			let rotationThisFrame = min(maxRotationThisFrame, abs(angleToTarget)) * sign(angleToTarget)
			
			// Create a rotation quaternion
			let rotation = simd_quaternion(rotationThisFrame, SIMD3<Float>(0, 1, 0))
			return rotation
		}
		throw RealityError.componemtError
		}
	
	private func updateTowardsRotation(deltaTime: Float, target: SIMD3<Float>)throws -> simd_quatf {
		let rotSpeed:Float = 1
		if let entityTransform = entity?.transformMatrix(relativeTo: nil){
			
			// Calculate current direction and target direction
			let currentPosition = SIMD3<Float>(entityTransform.columns.3.x, entityTransform.columns.3.y, entityTransform.columns.3.z)
			let directionToTarget = normalize(target - currentPosition)
			let currentForward = normalize(SIMD3<Float>(entityTransform.columns.2.x, 0, entityTransform.columns.2.z))
			
			// Calculate angle to target in radians
			let angleToTarget = atan2(directionToTarget.x, directionToTarget.z) - atan2(currentForward.x, currentForward.z)
			
			// Determine the amount to rotate this frame
			let maxRotationThisFrame = rotSpeed * deltaTime
			let rotationThisFrame = min(maxRotationThisFrame, abs(angleToTarget)) * sign(angleToTarget)
			
			// Create a rotation quaternion
			let rotation = simd_quaternion(rotationThisFrame, SIMD3<Float>(0, -1, 0))
			return rotation
		}
			
		throw RealityError.componemtError
			
		}

	
	


    
   func updateUpPosition(deltaTime: TimeInterval){
	   if var mc:ButterflyMotionComponent = entity!.components[ButterflyMotionComponent.self]{
		   do{
			   let mp = moveTowards(targetPosition: mc.skyTarget, from: entity!.position, speed: upAccel, deltaTime: deltaTime)
			   entity!.position = mp
			   let r = try updateRotation(deltaTime: Float(deltaTime), target: mc.skyTarget)
			   entity!.transform.rotation *= r
			   //entity.transform.rotation *= simd_quatf(angle: rot, axis: [0, 1, 0])
			   // print(mp.debugDescription)
			   if(mc.skyTarget == entity!.position ){
				   print("met sky target:")
				   mc.setState(state: .flyingDown)
				   entity!.components[ButterflyMotionComponent.self] = mc
				   upAccel = 0.01
			   }
			   //  else{
			   
			   upAccel = upAccel * 1.04
		   }catch{
			   print(error)
		   }
	   }
	}
        

	
	func doTakeOff(){
		if var mc:ButterflyMotionComponent = entity?.components[ButterflyMotionComponent.self]{
			mc.setAnimation(animation: mc.animator.setAnimation(entity: entity!, name: "takeOff", trans: 0.2))
			mc.animation?.speed = 1.5
			mc.setState(state: .flyingUp)
			entity?.components[ButterflyMotionComponent.self] = mc
			arView?.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: entity) {event in
				if event.playbackController == mc.animation {
					mc.setAnimation(animation: mc.animator.setAnimation(entity: self.entity!, name: "fly", trans: 0.2))
					mc.animation?.speed = 1.8
					//mc.setState(state: .flyingUp)
					self.entity!.components[ButterflyMotionComponent.self] = mc
				}
			}.store(in: &subscriptions)
			mc.setSkyPosition(tp: [Float.random(in: -5 ... 5), Float.random(in: 8 ... 15), Float.random(in: -6 ... 10)])
			entity!.components[ButterflyMotionComponent.self] = mc
		}
	}
	
	
//
//	func doLanding(){
//		if var mc:MotionComponent = entity.components[MotionComponent.self]{
//			
//			entity.components[MotionComponent.self] = mc
//			mc.setAnimation(animation: mc.animator.setAnimation(entity: entity, name: "land", trans: 0.1))
//			arView.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: entity) {event in
//				if event.playbackController == mc.animation {
//					mc.setAnimation(animation: mc.animator.setAnimation(entity: self.entity, name: "idle", trans: 0.3))
//					mc.animation?.speed = 0.2
//					mc.setState(state: .landed)
//					self.entity.components[MotionComponent.self] = mc
//				}
//			}.store(in: &subscriptions)
//		}
//	}
//    
    
    func moveTowards(targetPosition: SIMD3<Float>, from currentPosition: SIMD3<Float>, speed: Float, deltaTime: TimeInterval) -> SIMD3<Float> {
       

		let vectorToTarget = targetPosition - currentPosition
        let distanceToTarget = simd_length(vectorToTarget)
        
        // Check if we are close enough to consider as arrived
        if distanceToTarget < 0.01 {
            return targetPosition
        }
        
        let directionToTarget = vectorToTarget / distanceToTarget
        let movementThisStep = min(distanceToTarget, speed * Float(deltaTime))
        
        return currentPosition + directionToTarget * movementThisStep
    }
}
