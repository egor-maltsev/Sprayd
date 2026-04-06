//
//  SpraydApp.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import SwiftData

@main
struct SpraydApp: App {
    private let sharedModelContainer: ModelContainer
    private let compositionRoot: CompositionRoot

    init() {
        let modelContainer = ArtDataStore.sharedModelContainer
        self.sharedModelContainer = modelContainer
        self.compositionRoot = CompositionRoot(context: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(compositionRoot: compositionRoot)
                .tint(.accentRed)
        }
        .modelContainer(sharedModelContainer)
    }
}
