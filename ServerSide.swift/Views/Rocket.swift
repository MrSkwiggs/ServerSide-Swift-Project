//
//  Rocket.swift
//  ServerSide.swift
//
//  Created by Dorian on 05/12/2022.
//

import SwiftUI
import EffectsLibrary

struct Rocket: View {
    
    @Binding
    var progress: CGFloat
        
    private var quadEase: CGFloat {
        if progress == 1 { return 0 }
        return 1 - pow(1 - progress, 3)
    }
    
    var body: some View {
            Text("🚀")
                .font(.system(size: 40))
                .rotationEffect(.degrees(progress == 1 ? 135 : -45))
                .background {
                        FireView(config: .init(initialVelocity: .fast, spreadRadius: .high))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: 400, height: 500)
                            .scaleEffect(x: 0.1, y: quadEase)
                            .rotationEffect(.radians(.pi))
                            .offset(y: 20)
                            .opacity(progress > 0 ? 1 : 0.001)
                }
                .animation(.easeOut, value: progress)
    }
}

struct Rocket_Previews: PreviewProvider {
    static var previews: some View {
        Rocket(progress: .constant(0))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        
        Rocket(progress: .constant(1))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .previewDisplayName("Launched Rocket")
        
    }
}
