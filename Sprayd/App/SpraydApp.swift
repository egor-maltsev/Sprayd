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
    private let modelContainer = ArtDataStore.sharedModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.accentRed)
        }
        .modelContainer(modelContainer)
    }
}
