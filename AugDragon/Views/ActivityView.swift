//
//  ActivityView.swift
//  AugDragon
//
//  Created by Peter Rogers on 19/01/2024.
//

import Foundation
import SwiftUI

struct ActivityView: View{
	@State var degreesRotating = 0.0
	@State var animationCount = 2.0
	@State var bounceMe = true
	var body: some View{
		VStack{
			Image(systemName: "fireworks")
				.font(.system(size: 80))
				.foregroundStyle(.lowLighter, .highLighter)
				.symbolEffect(.bounce, options: .speed(1).repeating, value: bounceMe)
				.symbolEffect(.variableColor.iterative, options: .repeating, value: bounceMe)
				.rotationEffect(.degrees(degreesRotating))
				.onAppear {
					withAnimation(.linear(duration: 4)
						.speed(1).repeatForever(autoreverses: false)) {
							degreesRotating = 360.0
					}
				bounceMe.toggle()
			}
		}
	}
}

#Preview {
	
	ActivityView()
	
}
