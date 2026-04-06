//
//  SwiftData.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import Foundation
import SwiftData

enum ArtDataStore {
    enum SharedLoadState {
        case ready
        case failed
    }

    static private(set) var sharedLoadState: SharedLoadState = .ready
    static let sharedModelContainer = makeModelContainer(
        seedSampleData: shouldSeedSharedData,
        trackSharedLoadState: true
    )
    static let previewModelContainer = makeModelContainer(
        inMemoryOnly: true,
        seedSampleData: true
    )

    private static var shouldSeedSharedData: Bool {
        #if DEBUG
        true
        #else
        false
        #endif
    }

    static func makeModelContainer(
        inMemoryOnly: Bool = false,
        seedSampleData: Bool = false,
        trackSharedLoadState: Bool = false
    ) -> ModelContainer {
        let schema = Schema([
            ArtItem.self,
            ArtImage.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemoryOnly
        )

        do {
            let container = try makeContainer(
                schema: schema,
                configuration: configuration,
                seedSampleData: seedSampleData
            )
            if trackSharedLoadState {
                sharedLoadState = .ready
            }
            return container
        } catch {
            guard !inMemoryOnly else {
                fatalError("Failed to create in-memory container: \(error)")
            }

            if trackSharedLoadState {
                sharedLoadState = .failed
            }
            assertionFailure("Failed to create persistent model container: \(error)")

            do {
                let fallbackConfiguration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: true
                )
                return try makeContainer(
                    schema: schema,
                    configuration: fallbackConfiguration,
                    seedSampleData: seedSampleData
                )
            } catch {
                fatalError("Failed to create fallback in-memory container: \(error)")
            }
        }
    }

    private static func makeContainer(
        schema: Schema,
        configuration: ModelConfiguration,
        seedSampleData: Bool
    ) throws -> ModelContainer {
        let container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )

        if seedSampleData {
            try seedIfNeeded(in: container)
        }

        return container
    }

    private static func seedIfNeeded(in container: ModelContainer) throws {
        let context = ModelContext(container)

        guard try context.fetchCount(FetchDescriptor<ArtItem>()) == 0 else {
            return
        }

        makeSeedItems().forEach(context.insert)
        try context.save()
    }

    private static func makeSeedItems(referenceDate: Date = .now) -> [ArtItem] {
        [
            ArtItem(
                name: "The Gliders",
                itemDescription: "A large-scale mural about movement through a dense urban landscape.",
                images: ["https://picsum.photos/id/1011/600/400"],
                location: "St. Petersburg",
                author: "Ana Markov",
                uploadedBy: "Loxxych",
                uploadedAt: referenceDate.addingTimeInterval(-3_600),
                state: .moderated,
                category: "Mural",
                likesCount: 22,
                latitude: 59.9343,
                longitude: 30.3351
            ),
            ArtItem(
                name: "Screams",
                itemDescription: "A distressed character study painted on a concrete underpass wall.",
                images: ["https://picsum.photos/id/1025/600/400"],
                location: "Moscow",
                author: "Ana Markov",
                uploadedBy: "Egor Maltsev",
                uploadedAt: referenceDate.addingTimeInterval(-7_200),
                state: .new,
                category: "Graffiti",
                likesCount: 18,
                latitude: 55.7558,
                longitude: 37.6176
            ),
            ArtItem(
                name: "Bird District",
                itemDescription: "A colorful neighborhood intervention inspired by local birds and roofs.",
                images: ["https://picsum.photos/id/1035/600/400"],
                location: "Kazan",
                author: "Mira Volnova",
                uploadedBy: "Loxxych",
                uploadedAt: referenceDate.addingTimeInterval(-10_800),
                state: .moderated,
                category: "Street art",
                likesCount: 14,
                latitude: 55.7961,
                longitude: 49.1064
            ),
            ArtItem(
                name: "Cube Signal",
                itemDescription: "Geometric work with a strong contrast palette and industrial rhythm.",
                images: ["https://picsum.photos/id/1043/600/400"],
                location: "Yekaterinburg",
                author: "Mira Volnova",
                uploadedBy: "Ana Markov",
                uploadedAt: referenceDate.addingTimeInterval(-14_400),
                state: .exists,
                category: "Installation",
                likesCount: 11,
                latitude: 56.8389,
                longitude: 60.6057
            ),
            ArtItem(
                name: "North Wall",
                itemDescription: "A weathered mural documented after restoration work in spring.",
                images: ["https://picsum.photos/id/1050/600/400"],
                location: "Veliky Novgorod",
                author: "Egor Maltsev",
                uploadedBy: "Ana Markov",
                uploadedAt: referenceDate.addingTimeInterval(-18_000),
                state: .exists,
                category: "Mural",
                likesCount: 9,
                latitude: 58.5215,
                longitude: 31.2755
            )
        ]
    }
}
