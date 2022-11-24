//
//  ContentView+ViewModel.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import Foundation
import Combine

extension ContentView {
    class ViewModel: ObservableObject {
        @Published
        var progress: CGFloat = 0
        
        @Published
        var didWin: Bool = false
        
        @Published
        var clients: Int = 0
        
        @Published
        var ip: String = ""
        
        /// Used to continuously reduce the progress made by players
        private var timer: Timer?
        
        private var server: Server? = .init()
        
        private var subscriptions: [AnyCancellable] = []
        
        init() {
            timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { timer in
                self.pull()
            })
            server?
                .$status
                .receive(on: DispatchQueue.main)
                .sink { [weak self] status in
                    if case let .running(ip) = status {
                        self?.ip = ip
                    }
                }
                .store(in: &subscriptions)
            
            server?
                .pushPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.push()
                })
                .store(in: &subscriptions)
            
            server?
                .clientsPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] clients in
                    self?.clients = clients
                }
                .store(in: &subscriptions)
            server?.start()
        }
        
        private func push() {
            guard clients > 0 else { return }
            progress = min(100, progress + CGFloat((5 / clients)))
            didWin = didWin || progress == 100
            
            if didWin { timer?.invalidate() }
        }
        
        private func pull() {
            progress = max(0, progress - (10 / 60))
        }
    }
}
