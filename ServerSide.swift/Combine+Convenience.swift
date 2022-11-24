//
//  Combine+Convenience.swift
//  ServerSide.swift
//
//  Created by Dorian on 24/11/2022.
//

import Foundation
import Combine

extension CurrentValueSubject where Output == Int {
    func increment(by increment: Int = 1) {
        send(value + increment)
    }
}
