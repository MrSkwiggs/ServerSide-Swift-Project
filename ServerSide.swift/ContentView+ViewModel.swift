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
        var magicWord: String = ""
    }
}
