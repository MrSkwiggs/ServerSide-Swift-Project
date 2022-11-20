//
//  Player.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import Foundation

struct Player: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
}
