//
//  SwiftData.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import Foundation
import SwiftData

private let artSchema = Schema([
    Author.self,
    ArtItem.self,
    ArtImage.self
])

let sharedModelContainer: ModelContainer = {
    let configuration = ModelConfiguration(
        schema: artSchema,
        url: storeURL
    )

    do {
        return try ModelContainer(
            for: artSchema,
            configurations: [configuration]
        )
    } catch {
        resetPersistentStore()

        do {
            return try ModelContainer(
                for: artSchema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to create model container after reset: \(error)")
        }
    }
}()

private let storeURL: URL = {
    let appSupportURL = URL.applicationSupportDirectory
    let storeDirectoryURL = appSupportURL.appending(path: "Sprayd", directoryHint: .isDirectory)

    try? FileManager.default.createDirectory(
        at: storeDirectoryURL,
        withIntermediateDirectories: true
    )

    return storeDirectoryURL.appending(path: "Sprayd.store")
}()

private func resetPersistentStore() {
    let fileManager = FileManager.default
    let storeRelatedURLs = [
        storeURL,
        storeURL.appendingPathExtension("shm"),
        storeURL.appendingPathExtension("wal")
    ]

    for url in storeRelatedURLs where fileManager.fileExists(atPath: url.path) {
        try? fileManager.removeItem(at: url)
    }
}
