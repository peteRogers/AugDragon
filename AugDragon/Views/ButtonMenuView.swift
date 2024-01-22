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
					Image(systemName: "person.crop.rectangle.badge.plus")
						.font(.system(size:50))
						.foregroundColor(.buttonscolor)
					
				}.padding()
				Button(action: {
					cvm.viewState = .showInstructions
				}) {
					Image(systemName: "signpost.right.and.left")
						.font(.system(size:50))
						.foregroundColor(.buttonscolor)
				}.padding()
			}
			if(cvm.viewState == .showPhotoPreview){
				Spacer()
				Button(action: {
					cvm.viewState = .showHome
				}) {
					Image(systemName: "arrow.left.circle")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
				}
				Spacer()
				Button(action: {
					cvm.viewState = .showCamera
				}) {
					Image(systemName: "camera.circle")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
				}
				Spacer()
				Button(action: {
					cvm.showProgress = true
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						cvm.viewState = .showMaskView
					}
				}) {
					Image(systemName: "arrow.up.heart")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
				}
				Spacer()
			
			}
			if (cvm.viewState == .showMaskView ||
				cvm.viewState == .showInstructions ||
				cvm.viewState == .showCamera)
			{
				Spacer()
				Button(action: {
					
					cvm.viewState = .showHome
				}) {
					Image(systemName: "arrow.left.circle")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
				}
				Spacer()
			}
		}
	}
}
