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
					Image(systemName: "person.fill.badge.plus")
						.font(.system(size:50))
						.foregroundColor(.buttonscolor)
					
				}.padding()
				Button(action: {
					cvm.viewState = .showCamera
				}) {
					Image(systemName: "info.square")
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
					#warning("This needs to be encapsulated inside viewModel")
					cvm.viewState = .showMaskView
					cvm.tryToSaveMask()
				}) {
					Image(systemName: "arrow.up.heart")
						.font(.system(size: 50))
						.foregroundColor(.buttonscolor)
				}
				Spacer()
			
			}
			if(cvm.viewState == .showMaskView){
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
