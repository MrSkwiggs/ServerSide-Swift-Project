//
//  Launch+ViewModel.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import Foundation
import Combine

extension Launch {
    class ViewModel: ObservableObject {
        @Published
        var progress: CGFloat = 0
        
        @Published
        var didWin: Bool = false
        
        @Published
        var sessions: Set<String> = []
        
        @Published
        var ip: String = ""
        
        @Published
        private(set) var isLaunchInProgress: Bool = false
        
        @Published
        var countdown: String?
        
        var id: Int = 1
        
        var gameOverViewModel: GameOver.ViewModel!
        
        /// Used to continuously reduce the progress made by players
        private var timer: Timer?
        
        private var server: Server? = .init()
        
        private var subscriptions: [AnyCancellable] = []
        
        init(sessions: Set<String> = []) {
            self.sessions = sessions
            
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
                .sessionIDsPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] sessions in
                    self?.sessions = sessions
                }
                .store(in: &subscriptions)
            server?.start()
        }
        
        /// For test purposes, randomly adds 180 participants
        private func increaseSession() {
            sessions.insert("\(id)")
            id += 1
            guard id < 180 else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(.random(in: 0...5) == 5 ? .random(in: 200...1000) : .random(in: 10...100))) {
                self.increaseSession()
            }
        }
        
        func start() {
            isLaunchInProgress = true
            countdown(5) { [weak self] value in
                self?.countdown = "\(value)"
                self?.server?.sendCountdown(value)
            } onComplete: { [weak self] in
                self?.countdown = "Launch!"
                self?.scheduleTimer()
                self?.server?.sendHasLaunched()
                self?.gameOverViewModel = .init()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self?.countdown = nil
                }
            }
        }
        
        func reset() {
            progress = 0
            didWin = false
            isLaunchInProgress = false
            server?.reset()
        }
        
        private func scheduleTimer() {
            guard timer == nil else { return }
            timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { timer in
                self.pull()
            })
        }
        
        private func countdown(_ value: Int, onCountdown: @escaping (Int) -> Void, onComplete: @escaping () -> Void) {
            guard value != 0 else {
                onComplete()
                return
            }
            onCountdown(value)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                self.countdown(value - 1, onCountdown: onCountdown, onComplete: onComplete)
            }
        }
        
        private func push() {
            guard !sessions.isEmpty else { return }
            let difficulty = sessions.count
            progress = min(1, progress + CGFloat((0.05 / Double(difficulty))))
            didWin = didWin || progress == 1
            
            gameOverViewModel.amountOfPushes += 1
            
            if didWin {
                gameOverViewModel.numberOfPlayers = sessions.count
                gameOverViewModel.gameOver()
                timer?.invalidate()
                timer = nil
                server?.sendHasWon()
            }
        }
        
        private func pull() {
            progress = max(0, progress - (0.1 / 60))
        }
    }
}
