//
//  Launch.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import SwiftUI
import EffectsLibrary

struct Launch: View {
    
    @StateObject
    var viewModel: ViewModel
    
    @State
    private var showQRCode: Bool = false
    
    @State
    private var showsGameOverScreen: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("🌒")
                .onTapGesture {
                    if viewModel.isLaunchInProgress {
                        viewModel.reset()
                    } else {
                        viewModel.start()
                    }
                }
            Spacer()
            GeometryReader { content in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Rocket(progress: $viewModel.progress)
                            .offset(y: 20)
                            .offset(y: -(viewModel.progress) * content.size.height)
                    }
                    Spacer()
                }
            }
            Text("🌍")
                .overlay {
                    Astronauts(astronauts: viewModel.sessions.count)
                }
                .zIndex(-1)
        }
        .font(.system(size: 100))
        .padding()
        .padding(.bottom, 20)
        .background(
            Color.black
                .overlay(content: {
                    if viewModel.didWin {
                        FireworksView(config: .init(intensity: .high))
                    }
                })
        )
        .onTapGesture {
            showQRCode = true
        }
        .animation(.easeOut, value: viewModel.didWin)
        .sheet(isPresented: $showQRCode) {
            VStack {
                Text(viewModel.ip)
                    .font(.largeTitle)
                    .bold()
                QRCode(ip: viewModel.ip)
            }
        }
        .overlay {
            Text(viewModel.countdown ?? "")
                .font(.system(size: 100))
                .animation(.easeOut(duration: 0.2),
                           value: viewModel.countdown)
        }
        .overlay {
            if showsGameOverScreen {
                GameOver(viewModel: viewModel.gameOverViewModel)
            }
        }
        .onChange(of: viewModel.didWin) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                withAnimation {
                    self.showsGameOverScreen = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var sessions: Set<String> {
        var s = Set<String>()
        for i in 0..<15 {
            s.insert("\(i)")
        }
        return s
    }
    
    static var previews: some View {
        Launch(viewModel: .init(sessions: sessions))
    }
}

