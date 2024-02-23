//
//  ButtonMenuView.swift
//  AugDragon
//
//  Created by Peter Rogers on 12/01/2024.
//

import Foundation
import SwiftUI

struct ButtonMenuView: View{
	@ObservedObject var cvm:CameraViewModel
	var body: some View{
		HStack{
			if(cvm.viewState == .showHome){
				Button(action: {
					cvm.viewState = .showCamera
				}) {
					Image(systemName: "camera.circle")
						.font(.system(size:50))
						.foregroundColor(.highLighter)
					
				}.padding()
				Button(action: {
					cvm.viewState = .showInstructions
				}) {
					Image(systemName: "info.circle")
						.font(.system(size:50))
						.foregroundColor(.highLighter)
				}.padding()
			}
			if(cvm.viewState == .showPhotoPreview || cvm.viewState == .showPhotoSettings){
				Spacer()
				Button(action: {
					cvm.viewState = .showHome
				}) {
					Image(systemName: "arrow.down.backward.circle")
						.font(.system(size: 50))
						.foregroundColor(.lowLighter)
				}
				Spacer()
				Button(action: {
					cvm.viewState = .showCamera
				}) {
					Image(systemName: "camera.circle")
						.font(.system(size: 50))
						.foregroundColor(.lowLighter)
				}
				Spacer()
				Button(action: {
					if(cvm.viewState == .showPhotoPreview){
						cvm.viewState = .showPhotoSettings
					}else{
						cvm.viewState = .showPhotoPreview
					}
				}) {
					Image(systemName: "circle.bottomrighthalf.checkered")
						.font(.system(size: 50))
						.foregroundColor(.lowLighter)
				}
				Spacer()
				Button(action: {
					//SAVE//
					cvm.showProgress = true
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
						print("launching maskView")
						cvm.saveMat()
					}
				}) {
					Image(systemName: "arrow.up.heart")
						.font(.system(size: 50))
						.foregroundColor(.lowLighter)
				}
				Spacer()
			
			}
			if (cvm.viewState == .showMaskView ||
				cvm.viewState == .showInstructions ||
				cvm.viewState == .showCamera)
			{
				//Spacer()
				Button(action: {
					cvm.viewState = .showHome
				}) {
					Image(systemName: "arrow.down.backward.circle")
						.font(.system(size: 50))
						.foregroundColor(.lowLighter)
				}
				Spacer()
			}
		}
	}
}
