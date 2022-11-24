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
        }
        .font(.system(size: 100))
        .padding()
        .background(
            viewModel.didWin ? Color.green : .black
        )
        .animation(.easeOut, value: viewModel.didWin)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
