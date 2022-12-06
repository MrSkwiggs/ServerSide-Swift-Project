//
//  GameOver.swift
//  ServerSide.swift
//
//  Created by Dorian on 06/12/2022.
//

import SwiftUI

struct GameOver: View {
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("You made it!")
                .font(.largeTitle)
            HStack {
                Text("It took ")
                + Text("\(viewModel.numberOfPlayers)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                + Text(" astronauts")
            }
            HStack {
                Text("about ")
                + Text("\(viewModel.amountOfPushes)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
                + Text(" collective taps")
            }
            HStack {
                Text("and ")
                + Text("\(viewModel.startTime..<viewModel.endTime, format: .timeDuration)s")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.orange)
                + Text(" to reach the moon")
            }
        }
        .foregroundColor(.white)
        .font(.title)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

struct GameOver_Previews: PreviewProvider {
    
    static let model: GameOver.ViewModel = {
        let model = GameOver.ViewModel()
        model.numberOfPlayers = 38
        model.amountOfPushes = 174
        model.endTime = .now.addingTimeInterval(43)
        return model
    }()
    
    static var previews: some View {
        GameOver(viewModel: model)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
