//
//  ContentView.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import SwiftUI
import EffectsLibrary

struct ContentView: View {
    
    @StateObject
    var viewModel: ViewModel
    
    @State
    private var showQRCode: Bool = false
    
    @State
    private var rotation: CGFloat = 0.0
    
    var body: some View {
        VStack(spacing: 0) {
            Text("🌒")
                .onTapGesture {
                    viewModel.progress = 0
                    viewModel.didWin = false
                }
            Spacer()
            GeometryReader { content in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Rocket(progress: $viewModel.progress)
                            .offset(y: 20)
                            .offset(y: -(viewModel.progress / 100) * content.size.height)
                    }
                    Spacer()
                }
            }
            Text("🌍")
                .onTapGesture {
                    showQRCode = true
                }
                .overlay {
                    Astronauts(astronauts: viewModel.sessions.count)
                }
                .zIndex(-1)
            if !viewModel.isLaunchInProgress {
                Button {
                    viewModel.start()
                } label: {
                    Text("Launch")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
        .font(.system(size: 100))
        .padding()
        .background(
            Color.black
                .overlay(content: {
                    if viewModel.didWin {
                        FireworksView(config: .init(intensity: .high))
                    }
                })
        )
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
        .onAppear {
            withAnimation(.linear(duration: 5).speed(0.1).repeatForever(autoreverses: false)) {
                rotation = 360
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
        ContentView(viewModel: .init(sessions: sessions))
    }
}

