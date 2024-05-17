import SwiftUI
import RealityKit

struct MaskViewControllerReprentable: UIViewControllerRepresentable {
	var mat: Mat
	var showProgress:Bool
	
	func makeCoordinator() -> Coordinator {
		//	class Coordinator: NSObject{
		return Coordinator(self, mat: mat)
		//	}
	}
	
	
	class Coordinator: NSObject{
		var parent: MaskViewControllerReprentable
		var mat: Mat
		
		
		init(_ parent: MaskViewControllerReprentable, mat: Mat) {
			self.mat = mat
			self.parent = parent
			
			
		}
	}
	
	func makeUIViewController(context: Context) -> MaskViewController {
		let viewController = MaskViewController()
		viewController.coordinator = context.coordinator
		return viewController
	}

	func updateUIViewController(_ uiViewController: MaskViewController, context: Context) {
		// Update the ARView if needed
	}
}
