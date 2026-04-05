//
//  ContentView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View {
    private let compositionRoot: CompositionRoot

    init(compositionRoot: CompositionRoot) {
        self.compositionRoot = compositionRoot
    }

    var body: some View {
        AppCoordinatorView(compositionRoot: compositionRoot)
    }
}
