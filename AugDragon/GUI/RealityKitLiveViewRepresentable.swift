import SwiftUI
import RealityKit

struct RealityKitLiveViewRepresentable: UIViewControllerRepresentable {
	var mat: Mat
	var showProgress:Bool
	
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
		viewController.coordinator = context.coordinator
		return viewController
	}

	func updateUIViewController(_ uiViewController: RealityViewController, context: Context) {
		// Update the ARView if needed
	}
}
