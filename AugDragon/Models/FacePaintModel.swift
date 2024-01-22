//
//  FacePaintModel.swift
//  SwiftUIARKit
//
//  Created by Peter Rogers on 11/01/2024.
//

import Foundation

import ARKit
import UIKit

class FacePaintModel: NSObject, ARSCNViewDelegate, ObservableObject, ARSessionDelegate {
	@Published var message:String = "starting AR"
	private var arView: ARSCNView!
	var faceAnchorsAndContentControllers: [ARFaceAnchor: FacePaintController] = [:]
	
	func setARView(_ arView: ARSCNView) {
		
		self.arView = arView
		arView.delegate = self
		//arView.session.delegate = self
		arView.automaticallyUpdatesLighting = true
		arView.scene = SCNScene()
		resetTracking()
		
	}
	
	func resetTracking() {
		guard ARFaceTrackingConfiguration.isSupported else { return }
		let configuration = ARFaceTrackingConfiguration()
		if #available(iOS 13.0, *) {
			configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
		}
		configuration.isLightEstimationEnabled = true
		self.arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
		faceAnchorsAndContentControllers.removeAll()
	}

	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let faceAnchor = anchor as? ARFaceAnchor else { return }
		DispatchQueue.main.async {
			let contentController = TexturedFace()
			if node.childNodes.isEmpty, let contentNode = contentController.renderer(renderer, nodeFor: faceAnchor) {
				node.addChildNode(contentNode)
				self.faceAnchorsAndContentControllers[faceAnchor] = contentController
			}
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let faceAnchor = anchor as? ARFaceAnchor,
			let contentController = faceAnchorsAndContentControllers[faceAnchor],
			let contentNode = contentController.contentNode else {
			return
		}
		contentController.renderer(renderer, didUpdate: contentNode, for: anchor)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		guard let faceAnchor = anchor as? ARFaceAnchor else { return }
		faceAnchorsAndContentControllers[faceAnchor] = nil
	}
}

protocol FacePaintController: ARSCNViewDelegate {
	/// The root node for the virtual content.
	var contentNode: SCNNode? { get set }
	
	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
}

class TexturedFace: NSObject, FacePaintController {
	
	var contentNode: SCNNode?
	
	/// - Tag: CreateARSCNFaceGeometry
	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
		guard let sceneView = renderer as? ARSCNView,
			  anchor is ARFaceAnchor else { return nil }
		
//#if targetEnvironment(simulator)
//#error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
//#else
		let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
		if let material = faceGeometry.firstMaterial{
			if let inImage = UIImage(named: "imgTest2"){
				if let inputImage = CIImage(image: inImage) {
					if let exposureAdjustFilter = CIFilter(name: "CIExposureAdjust"){
						exposureAdjustFilter.setValue(inputImage, forKey: kCIInputImageKey)
						exposureAdjustFilter.setValue(0.6, forKey: kCIInputEVKey)
						if let outputImage = exposureAdjustFilter.outputImage!.removeWhitePixels(){
							let context = CIContext(options: nil)
							if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
								let outputUIImage = UIImage(cgImage: cgImage)
								material.diffuse.contents = outputUIImage
								material.lightingModel = .physicallyBased
							}
						}
					}
				}
			}
		}
		contentNode = SCNNode(geometry: faceGeometry)
//#endif
		return contentNode
	}
	
	/// - Tag: ARFaceGeometryUpdate
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
			let faceAnchor = anchor as? ARFaceAnchor
		else {
			return
		}
		faceGeometry.update(from: faceAnchor.geometry)
	}
}


extension CIImage {

	func removeWhitePixels() -> CIImage? {
		let chromaCIFilter = chromaKeyFilter()
		chromaCIFilter?.setValue(self, forKey: kCIInputImageKey)
		
		return chromaCIFilter?.outputImage
	}

	func composite(with mask: CIImage) -> CIImage? {
		return CIFilter(
			name: "CISourceOutCompositing",
			parameters: [
				kCIInputImageKey: self,
				kCIInputBackgroundImageKey: mask
			]
		)?.outputImage
	}

	func applyBlurEffect() -> CIImage? {
		let context = CIContext(options: nil)
		let clampFilter = CIFilter(name: "CIAffineClamp")!
		clampFilter.setDefaults()
		clampFilter.setValue(self, forKey: kCIInputImageKey)

		guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
		currentFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
		currentFilter.setValue(2, forKey: "inputRadius")
		guard let output = currentFilter.outputImage,
			  let cgimg = context.createCGImage(output, from: extent) else { return nil }

		return CIImage(cgImage: cgimg)
	}

	// modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
	private func chromaKeyFilter() -> CIFilter? {
		let size = 8
		var cubeRGB = [Float]()

		for z in 0 ..< size {
			let blue = CGFloat(z) / CGFloat(size - 1)
			for y in 0 ..< size {
				let green = CGFloat(y) / CGFloat(size - 1)
				for x in 0 ..< size {
					let red = CGFloat(x) / CGFloat(size - 1)
					let brightness = getBrightness(red: red, green: green, blue: blue)
					let alpha: CGFloat = brightness == 1.0 ? 0 : 1
					cubeRGB.append(Float(red * alpha))
					cubeRGB.append(Float(green * alpha))
					cubeRGB.append(Float(blue * alpha))
					cubeRGB.append(Float(alpha))
				}
			}
		}

		let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))

		let colorCubeFilter = CIFilter(
			name: "CIColorCube",
			parameters: [
				"inputCubeDimension": size,
				"inputCubeData": data
			]
		)
		return colorCubeFilter
	}

	// modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
	private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
		let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
		var brightness: CGFloat = 0
		color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
		return brightness
	}

}




