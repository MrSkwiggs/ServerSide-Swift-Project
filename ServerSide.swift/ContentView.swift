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
            Text("🌖")
            Spacer()
            GeometryReader { content in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("🚀")
                            .offset(y: -(viewModel.progress / 100) * content.size.height)
                    }
                    Spacer()
                }
            }
            Text("🌍")
            Button {
                viewModel.push()
            } label: {
                Text("Launch")
            }
            Text("\(viewModel.progress)")
        }
        .font(.system(size: 60))
        .padding()
        .background(
            viewModel.didWin ? Color.green : .clear
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
