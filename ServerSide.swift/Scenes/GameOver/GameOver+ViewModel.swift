//
//  GameOver+ViewModel.swift
//  ServerSide.swift
//
//  Created by Dorian on 06/12/2022.
//

import Foundation

extension GameOver {
    class ViewModel: ObservableObject {
        var numberOfPlayers: Int = 0
        var startTime: Date = .now
        var amountOfPushes: Int = 0
        
        var endTime: Date!
        
        func gameOver() {
            endTime = .now
        }
    }
}
