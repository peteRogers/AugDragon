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
	let bSize:CGFloat = 40
	var body: some View{
		HStack{
			if(cvm.viewState == .showHome){
				Button(action: {
					cvm.viewState = .showCamera
				}) {
					Image(systemName: "photo.badge.plus")
						.font(.system(size:bSize))
						.foregroundColor(.specAccent)
					
				}.padding()
				Button(action: {
					cvm.viewState = .showInstructions
				}) {
					Image(systemName: "info.circle")
						.font(.system(size:bSize))
						.foregroundColor(.specD)
				}.padding()
			}
			if(cvm.viewState == .showPhotoPreview || cvm.viewState == .showPhotoSettings){
				Spacer()
				Button(action: {
					cvm.viewState = .showHome
				}) {
					
					Image(systemName: "arrowshape.backward.circle.fill")
						.font(.system(size: bSize))
						.foregroundColor(.specD)
						//.environment(\.layoutDirection, .rightToLeft)
				}
				Spacer()
				Button(action: {
					cvm.viewState = .showCamera
				}) {
					Image(systemName: "camera.circle")
						.font(.system(size: bSize))
						.foregroundColor(.specD)
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
						.font(.system(size: bSize))
						.foregroundColor(.specD)
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
						.font(.system(size: bSize))
						.foregroundColor(.specAccent)
				}
				Spacer()
			
			}
			if(cvm.viewState == .showCamera){
				Button(action: {
					cvm.viewState = .showHome
				}) {
					Image(systemName: "figure.walk.motion")
						.font(.system(size: bSize))
						.foregroundColor(.specC)
						.flipsForRightToLeftLayoutDirection(true)
				}.padding(.leading, 10)
				Spacer()

				Button(action: {
					// Action to perform when the button is tapped
					cvm.showProgress = true
					cvm.callTakePhotoFunctionInUIKIT()
				}) {
					Image(systemName: "record.circle")
						.font(.system(size: bSize*2))
						.foregroundColor(.specAccent)
				}.padding(.top,0)
				Spacer()
				Button(action: {
					//cvm.viewState = .showHome
				}) {
					Image(systemName: "figure.walk.motion")
						.font(.system(size: bSize))
						.foregroundColor(.specC)
						.flipsForRightToLeftLayoutDirection(true)
				}.padding(.trailing, 10)
					.opacity(0)
					
		
			}
			if (cvm.viewState == .showMaskView ||
				cvm.viewState == .showInstructions)
			{
				//Spacer()
				Button(action: {
					cvm.viewState = .showHome
				}) {
					Image(systemName: "figure.walk.motion")
						.font(.system(size: bSize))
						.foregroundColor(.specC)
				}.padding(.leading, 10)
				Spacer()
			}
		}
	}
}
