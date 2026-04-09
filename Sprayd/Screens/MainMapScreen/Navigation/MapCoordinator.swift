//
//  MapCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
import Combine

final class MapCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [MapRoute] = []
    private let artItemsInBoxService: ArtItemsInBoxService
    private let locationProvider: LocationProvider

    // MARK: - Lifecycle
    init(
        artItemsInBoxService: ArtItemsInBoxService,
        locationProvider: LocationProvider
    ) {
        self.artItemsInBoxService = artItemsInBoxService
        self.locationProvider = locationProvider
    }
    
    // MARK: - Navigation logic
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    @ViewBuilder
    func makeRootView() -> some View {
        MainMapAssembly(
            artItemsInBoxService: artItemsInBoxService,
            locationProvider: locationProvider
        )
        .build()
    }
    
    @ViewBuilder
        func destination(for route: MapRoute) -> some View {
            // TODO: - Coordinate to designated route
        }
}
