//
//  Server.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import Foundation
import Vapor
import Leaf
import Combine

class Server: ObservableObject {
    @Published
    var status: Status = .stopped
    
    private let pushSubject: PassthroughSubject<Void, Never> = .init()
    lazy var pushPublisher: AnyPublisher<Void, Never> = pushSubject.eraseToAnyPublisher()
    
    private let clientsSubject: CurrentValueSubject<Int, Never> = .init(0)
    lazy var clientsPublisher: AnyPublisher<Int, Never> = clientsSubject.eraseToAnyPublisher()
    
    let app: Application
    
    init?() {
        let bundleURL = Bundle(for: Self.self).resourceURL!
        do {
            self.app = try Application(.detect())
            app.leaf.configuration.rootDirectory = bundleURL.appendingPathComponent("Files/Views").absoluteString
            app.views.use(.leaf)
            
            let file = FileMiddleware(publicDirectory: bundleURL.appendingPathComponent("Files/Public").path)
            app.middleware.use(file)
                        
            app.get { [weak self] request in
                self?.clientsSubject.increment()
                return request
                    .view
                    .render("button")
            }
            
            app.post { [weak self] request in
                self?.pushSubject.send()
                return "Thanks"
            }
            
            app.post("bye") { [weak self] request in
                if self?.clientsSubject.value ?? 0 > 0 {
                    self?.clientsSubject.increment(by: -1)
                }
                return "Bye"
            }
        } catch {
            return nil
        }
    }
    
    func start() {
        do {
            try app.server.start(address: .hostname("0.0.0.0", port: 80))
            guard let ip = System.localIPv4Address else {
                throw Error.noIP
            }
            status = .running(ip: "http://\(ip)")
        } catch {
            return
        }
    }
    
    func stop() {
        app.server.shutdown()
        status = .stopped
    }
}

extension Server {
    enum Error: Swift.Error {
        case noIP
    }
}
