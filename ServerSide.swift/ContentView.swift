//
//  ContentView.swift
//  ServerSide.swift
//
//  Created by Dorian on 20/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject
    var viewModel: ViewModel
    
    @State
    private var showQRCode: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("🌒")
            Spacer()
            GeometryReader { content in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("🚀")
                            .font(.system(size: 40))
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
            Text("Players: \(viewModel.clients)")
                .font(.body)
        }
        .font(.system(size: 100))
        .padding()
        .background(
            viewModel.didWin ? Color.green : .black
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
