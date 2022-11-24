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
        
        private var timer: Timer?
        
        private var server: Server? = .init()
        
        private var subscriptions: [AnyCancellable] = []
        
        init() {
            timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { timer in
                self.pull()
            })
            server?.start()
            server?
                .$status
                .sink { [weak self] status in
                    print(status)
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
                .sink { [weak self] clients in
                    print("clients: \(clients)")
                }
                .store(in: &subscriptions)
        }
        
        func push() {
            progress = min(100, progress + 5)
            didWin = didWin || progress == 100
            
            if didWin { timer?.invalidate() }
        }
        
        private func pull() {
            progress = max(0, progress - (10 / 60))
        }
    }
}
