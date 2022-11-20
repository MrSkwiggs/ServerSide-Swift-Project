//
//  Server+Status.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import Foundation

extension Server {
    enum Status {
        case stopped
        case running(GameController)
    }
}
