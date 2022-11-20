//
//  Server.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import Foundation
import Vapor

class Server: ObservableObject {
    @Published
    var status: Status = .stopped
}
