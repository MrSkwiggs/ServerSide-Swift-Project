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
        
        init() {
            timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { timer in
                self.pull()
            })
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
