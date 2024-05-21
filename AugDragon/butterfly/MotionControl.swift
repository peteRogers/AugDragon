//
//  MotionControl.swift
//  AugDragon
//
//  Created by Peter Rogers on 21/05/2024.
//

import Foundation

import simd

struct MotionControl {
	var position: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
	var velocity: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
	var rotation: SIMD3<Float> = SIMD3<Float>(0, 0, 0) // Rotation around x, y, z axes

	mutating func updatePosition(deltaTime: Float) {
		position += velocity * deltaTime
	}
	
	mutating func setVelocity(x: Float, y: Float, z: Float) {
		velocity = SIMD3<Float>(x, y, z)
	}
	
	mutating func moveVertical(speed: Float) {
		velocity.y += speed
	}
	
	mutating func moveHorizontal(speed: Float) {
		velocity.x += speed

		rotation.z += speed // bank to the left
	}
	
	
	
	mutating func moveForward(speed: Float) {
		velocity.z = speed
		rotation.x = -5.0 // slight nose down
	}
	
	mutating func moveBackward(speed: Float) {
		velocity.z = -speed
		rotation.x = 5.0 // slight nose up
	}
	
	mutating func resetRotation() {
		rotation = SIMD3<Float>(0, 0, 0)
	}
	
	// Function to handle banking and pitching based on velocity
	mutating func updateRotationBasedOnVelocity() {
		if velocity.x > 0 {
			rotation.z = -10.0 // bank to the right
		} else if velocity.x < 0 {
			rotation.z = 10.0 // bank to the left
		} else {
			rotation.z = 0.0 // no bank
		}
		
		if velocity.z > 0 {
			rotation.x = -5.0 // nose down
		} else if velocity.z < 0 {
			rotation.x = 5.0 // nose up
		} else {
			rotation.x = 0.0 // level
		}
	}
}
