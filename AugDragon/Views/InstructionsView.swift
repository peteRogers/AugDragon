//
//  InstructionsView.swift
//  AugDragon
//
//  Created by Peter Rogers on 19/01/2024.
//

import Foundation
import SwiftUI
import AVKit

struct InstructionsView: View{
	@ObservedObject var cvm:CameraViewModel
	
	var body: some View{
		let player = AVPlayer()
		ZStack{
			VStack{
				Rectangle()
			}.frame(maxHeight: .infinity)
				.edgesIgnoringSafeArea(.all)
			VStack{
				
				VideoPlayer(player: player)
					.frame(height: 400)
					.onAppear{
						if player.currentItem == nil {
							  let item = AVPlayerItem(url:  Bundle.main.url(forResource: "topDownAnim_1", withExtension: "mp4")!)
							  player.replaceCurrentItem(with: item)
						  }
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
							player.play()
							
						})
					}
				Spacer()
				ButtonMenuView(cvm: cvm)
			}
		}
	}
}
