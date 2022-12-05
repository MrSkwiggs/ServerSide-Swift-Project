//
//  Astronauts.swift
//  ServerSide.swift
//
//  Created by Dorian on 05/12/2022.
//

import SwiftUI

struct Astronauts: View {
    
    let astronauts: Int
    
    private static let characters: [String] = [
        "👨‍🚀", "🧑‍🚀", "👨‍🚀",
        "👩🏻‍🚀", "👩🏼‍🚀", "👩🏽‍🚀", "👩🏾‍🚀", "👩🏿‍🚀",
        "🧑🏻‍🚀", "🧑🏼‍🚀", "🧑🏽‍🚀", "🧑🏾‍🚀", "🧑🏿‍🚀",
    ]
    
    var chunks: [[String]] {
        Array<String>.init(repeating: "👤", count: astronauts)
            .chunked(by: 30)
    }

    var body: some View {
        ZStack {
            ForEach(Array(chunks.enumerated().reversed()), id: \.offset) { chunk in
                RotatingAstronauts(astronauts: chunk.element.joined(),
                                   reverses: chunk.offset % 2 == 0,
                                   size: CGFloat(140 + (chunk.offset * 20)),
                                   opacity: 1.0 - (Double(chunk.offset) * 0.2))
            }
        }
    }
}

fileprivate struct RotatingAstronauts: View {
    let astronauts: String
    let reverses: Bool
    let size: CGFloat
    let opacity: CGFloat
    
    @State
    private var rotation: CGFloat = 0.0
    
    var body: some View {
        CircleText(radius: 140,
                   text: astronauts,
                   fontSize: 18,
                   size: size)
        .shadow(color: .black, radius: 4)
        .opacity(opacity)
        .rotationEffect(.degrees(rotation))
        .animation(.linear(duration: 10).speed(0.1).repeatForever(autoreverses: false),
                   value: rotation)
        .onAppear {
            DispatchQueue.main.async {
                rotation = 360 * (reverses ? -1 : 1)
            }
        }
    }
}

struct Astronauts_Previews: PreviewProvider {
    
    static var previews: some View {
        Astronauts(astronauts: 150)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

extension Collection {
    func chunked(by count: Int) -> [[Element]] {
        var result: [[Element]] = []
        var increment = 0
        var current: [Element] = []
        forEach { item in
            current.append(item)
            increment += 1
            let alternatingCount = result.count % 2 == 0 ? count : count - 1
            if increment >= alternatingCount {
                result.append(current)
                current = []
                increment = 0
            }
        }
        result.append(current)
        return result
    }
}
