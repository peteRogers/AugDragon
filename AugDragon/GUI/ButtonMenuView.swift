//
//  ButtonMenuView.swift
//  AugDragon
//
//  Created by Peter Rogers on 12/01/2024.
//

import Foundation
import SwiftUI

struct ButtonMenuView: View{
	var cvm:CameraViewModel
	let bSize:CGFloat = 40
	var body: some View{
		HStack{
			if(cvm.viewState == .showHome){
				Button(action: {
					cvm.showCamera()
				}) {
					Image(systemName: "photo.badge.plus")
						.font(.system(size:bSize))
						.foregroundColor(.specAccent)
					
				}.padding()
				Button(action: {
					DispatchQueue.main.async {
						cvm.showInstructions()
					}
				}) {
					Image(systemName: "info.circle")
						.font(.system(size:bSize))
						.foregroundColor(.specD)
				}.padding()
			}
			if(cvm.viewState == .showPhotoPreview || cvm.viewState == .showPhotoSettings){
				Spacer()
				Button(action: {
					
						cvm.showHome()
					
				}) {
					
					Image(systemName: "arrowshape.backward.circle.fill")
						.font(.system(size: bSize))
						.foregroundColor(.specD)
						//.environment(\.layoutDirection, .rightToLeft)
				}
				Spacer()
				Button(action: {
					DispatchQueue.main.async {
						cvm.showCamera()
					}
				}) {
					Image(systemName: "camera.circle")
						.font(.system(size: bSize))
						.foregroundColor(.specD)
				}
				Spacer()
				Button(action: {
					if(cvm.viewState == .showPhotoPreview){
						
							cvm.showPhotoSettings()
						
					}else{
						
							cvm.showPhotoPreview()
						
					}
				}) {
					Image(systemName: "circle.bottomrighthalf.checkered")
						.font(.system(size: bSize))
						.foregroundColor(.specD)
				}
				Spacer()
				Button(action: {
					//SAVE//
					DispatchQueue.main.async {
						cvm.showProgressView(_show: true)
					}
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
					
					cvm.showHome()
					
				}) {
					Image(systemName: "figure.walk.motion")
						.font(.system(size: bSize))
						.foregroundColor(.specC)
						.flipsForRightToLeftLayoutDirection(true)
				}.padding(.leading, 10)
				Spacer()

				Button(action: {
					// Action to perform when the button is tapped
					//DispatchQueue.main.async {
						cvm.showProgressView(_show: true)
						cvm.callTakePhotoFunctionInUIKIT()
					//}
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
			if (cvm.viewState == .showMaskView 
				|| cvm.viewState == .showInstructions
				|| cvm.viewState == .showFacePaintView
				|| cvm.viewState == .showButterflyView)
			{
				//Spacer()
				Button(action: {
					
						cvm.showHome()
				
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
