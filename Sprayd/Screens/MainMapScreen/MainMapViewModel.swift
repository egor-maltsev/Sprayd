//
//  MainMapViewModel.swift
//  Sprayd
//
//  Created by User on 01.04.2026.
//

import Foundation
import MapKit

@MainActor
@Observable
final class MainMapViewModel {
    private enum Constants {
        static let regionChangeDebounceNanoseconds: UInt64 = 400_000_000
        static let minimumReloadInterval: TimeInterval = 1
    }

    var region: MKCoordinateRegion
    var items: [ArtItem]
    private let artItemsInBoxService: ArtItemsInBoxService
    private var lastLoadedBoundingBox: MapBoundingBox?
    private var lastLoadDate: Date?
    private var regionChangeTask: Task<Void, Never>?
    private var pendingRegion: MKCoordinateRegion?
    private var hasLoadedInitially = false
    private var isLoading = false

    init(
        region: MKCoordinateRegion,
        items: [ArtItem],
        artItemsInBoxService: ArtItemsInBoxService
    ) {
        self.region = region
        self.items = items
        self.artItemsInBoxService = artItemsInBoxService
    }

    func loadInitialItemsIfNeeded() async {
        guard !hasLoadedInitially else { return }

        hasLoadedInitially = true
        await loadItems(for: region, force: true)
    }

    func updateRegion(_ newRegion: MKCoordinateRegion) {
        region = newRegion

        regionChangeTask?.cancel()
        regionChangeTask = Task { @MainActor [weak self] in
            do {
                try await Task.sleep(nanoseconds: Constants.regionChangeDebounceNanoseconds)
            } catch {
                return
            }

            guard let self else { return }
            await self.loadItems(for: newRegion, force: false)
        }
    }

    private func loadItems(for region: MKCoordinateRegion, force: Bool) async {
        if isLoading {
            pendingRegion = region
            return
        }

        let boundingBox = MapBoundingBox(region: region)
        guard force || shouldLoadItems(for: boundingBox) else { return }

        if let lastLoadDate {
            let elapsed = Date().timeIntervalSince(lastLoadDate)
            if elapsed < Constants.minimumReloadInterval {
                let delay = Constants.minimumReloadInterval - elapsed

                do {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                } catch {
                    return
                }
            }
        }

        // Так как состояние могло измениться
        guard force || shouldLoadItems(for: boundingBox) else { return }

        isLoading = true
        let loadedItems = await artItemsInBoxService.loadArtItems(in: region)
        items = loadedItems
        lastLoadedBoundingBox = boundingBox
        lastLoadDate = Date()
        isLoading = false

        if let pendingRegion {
            self.pendingRegion = nil
            await loadItems(for: pendingRegion, force: false)
        }
    }

    private func shouldLoadItems(for boundingBox: MapBoundingBox) -> Bool {
        guard let lastLoadedBoundingBox else {
            return true
        }
        return !lastLoadedBoundingBox.contains(boundingBox)
    }
}
