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
    
    private let sessionIDsSubject: CurrentValueSubject<Set<String>, Never> = .init([])
    lazy var sessionIDsPublisher: AnyPublisher<Set<String>, Never> = sessionIDsSubject.eraseToAnyPublisher()
    
    private var sockets: [String: WebSocket] = [:]
    private var didLaunch: Bool = false
    private var didWin: Bool = false
    
    let app: Application
    
    init?() {
        let bundleURL = Bundle(for: Self.self).resourceURL!
        do {
            self.app = try Application(.detect())
            app.leaf.configuration.rootDirectory = bundleURL.appendingPathComponent("Files/Views").absoluteString
            app.views.use(.leaf)
            
            let file = FileMiddleware(publicDirectory: bundleURL.appendingPathComponent("Files/Public").path)
            app.middleware.use(file)
            
            app.middleware.use(app.sessions.middleware)
                        
            app.get { [weak self] request in
                return request
                    .view
                    .render("button")
            }
            
            app.get("register") { [weak self] request in
                guard let sessionID = request.session.id else {
                    return HTTPStatus.badRequest
                }
                self?.register(sessionID: sessionID.string)
                return HTTPStatus.ok
            }
            
            app.webSocket("countdown") { [weak self] request, socket in
                guard let self else { return }
                guard let sessionID = request.session.id else { return socket.close(promise: nil) }
                
                self.sockets[sessionID.string] = socket
                
                switch (self.didWin, self.didLaunch) {
                case (true, _):
                    socket.send("won")
                case (_, true):
                    socket.send("launch")
                default:
                    break
                }
            }
            
            app.post { [weak self] request in
                self?.register(sessionID: request.session.id?.string)
                self?.pushSubject.send()
                return "Thanks"
            }
            
            app.post("bye") { [weak self] request in
                guard let sessionID = request.session.id else {
                    return HTTPStatus.badRequest
                }
                self?.sessionIDsSubject.value.remove(sessionID.string)
                return HTTPStatus.ok
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
    
    func sendCountdown(_ countdown: Int) {
        send("\(countdown)")
    }
    
    func sendHasLaunched() {
        send("launch")
        didLaunch = true
    }
    
    func sendHasWon() {
        send("won")
        self.didWin = true
    }
    
    private func send(_ value: String) {
        sockets.forEach { _, socket in socket.send(value) }
    }
    
    private func register(sessionID: String?) {
        guard let sessionID else { return }
        sessionIDsSubject.value.insert(sessionID)
    }
}

extension Server {
    enum Error: Swift.Error {
        case noIP
    }
}
