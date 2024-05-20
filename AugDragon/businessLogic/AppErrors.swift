//
//  AppErrors.swift
//  AugDragon
//
//  Created by Peter Rogers on 17/01/2024.
//

import Foundation

enum QRCodeError: Error {
	case unableToCropQRMissing
	case noneFound
	case notAllFound
	case perspectiveError
}

enum CIFilterError: Error {
	case errorCompleting
	case transformFailure
	case vibrancyError
}

enum RealityError: Error {
	case modelLoadingError
	case componemtError
	
}

enum SavingError: Error {
	case noSavePNG
	case imageDataError
	case urlNotCreated
	case matUnableToBeCreatedError
}

enum CameraError: Error {
	case noFrontFaceCamera
	case noDeviceInput
}
