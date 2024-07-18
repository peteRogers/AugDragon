//
//  MotionControl.swift
//  AugDragon
//
//  Created by Peter Rogers on 21/05/2024.
//
import RealityKit
import simd
import Foundation

struct MotionController: Component {
	private(set) var position: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
	private(set) var velocity: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
	private(set) var rotation: SIMD3<Float> = SIMD3<Float>(0, 0, 0)

	mutating func updatePosition(deltaTime: Float) {
		position += velocity * deltaTime
	}

	mutating func updateRotationBasedOnVelocity() {
		if velocity.x != 0 {
			rotation.z = -(velocity.x * 10)
		}else{
			rotation.z = 0
		}

		if velocity.y != 0 {
			rotation.x = -(velocity.y * 10)
		}else{
			rotation.x = 0
		}

//		if velocity.z != 0 {
//			rotation.x = velocity.z > 0 ? -5.0 : 5.0
//		} else {
//			rotation.x = 0
//		}
	}
	
	mutating func changeVelocityFromStick(point: CGPoint){
		velocity.x  = (Float(point.x))
		velocity.y  = (Float(point.y))
	}
	
	mutating func setPosition(x: Float, y: Float, z: Float){
		
	}

	mutating func setVelocity(x: Float, y: Float, z: Float) {
		velocity = SIMD3<Float>(x, y, z)
	}

	mutating func addVelocity(x: Float, y: Float, z: Float) {
		velocity += SIMD3<Float>(x, y, z)
	}
}
