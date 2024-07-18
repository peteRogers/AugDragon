//
//  VirtualGameController.swift
//  AugDragon
//
//  Created by Peter Rogers on 21/05/2024.
//

import Foundation
import SwiftUI
import GameController

class GameControllerCoordinator: NSObject {
	var virtualController: GCVirtualController?
	var model: GameControllerModel

	init(model: GameControllerModel) {
		self.model = model
		super.init()
		setupVirtualController()
	}

	func setupVirtualController() {
		let configuration = GCVirtualController.Configuration()
		configuration.elements = [GCInputLeftThumbstick, GCInputRightThumbstick]
		
		virtualController = GCVirtualController(configuration: configuration)
		virtualController?.connect()
		
		virtualController?.controller?.extendedGamepad?.rightThumbstick.valueChangedHandler = { [weak self] (dpad, xValue, yValue) in
			self?.model.rightThumbstickValue = CGPoint(x: CGFloat(xValue), y: CGFloat(yValue))
		}
	}
}


struct GameControllerView: UIViewControllerRepresentable {
	var model: GameControllerModel

	func makeUIViewController(context: Context) -> UIViewController {
		let viewController = UIViewController()
		return viewController
	}

	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

	func makeCoordinator() -> GameControllerCoordinator {
		return GameControllerCoordinator(model: model)
	}
}


class GameControllerModel: ObservableObject {
	@Published var rightThumbstickValue: CGPoint = .zero
}
