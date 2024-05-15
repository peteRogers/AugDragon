//
//  StateEnums.swift
//  AugDragon
//
//  Created by Peter Rogers on 12/01/2024.
//

import Foundation


enum ViewState {
	case showCamera, showPhotoPreview, showHome,
		 showMaskView, showFacePaintView, showInstructions,  showPhotoSettings
}

enum MatType: String, Decodable, Encodable {
	case catMask = "Cat Mask",
		 facePaint = "Face Paint"
}

