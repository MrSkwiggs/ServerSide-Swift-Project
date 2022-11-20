//
//  GameController.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import Foundation
import Combine

class GameController: ObservableObject {
    let magicWord: String
    
    @Published
    var players: Set<Player> = []
    
    @Published
    var playerGuess: (Player, String)?
    
    @Published
    var winner: Player?
    
    init(magicWord: String) {
        self.magicWord = magicWord
    }
    
    func addPlayer(_ player: Player) {
        players.insert(player)
    }
    
    func playerDidGuess(playerID: String, guess: String) {
        guard let player = players.first(where: { $0.id == playerID }) else { return }
        
        if guess == magicWord {
            winner = player
        } else {
            playerGuess = (player, guess)
        }
    }
}
