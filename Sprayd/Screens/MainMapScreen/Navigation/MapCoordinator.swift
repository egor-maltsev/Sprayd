//
//  MapCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
internal import Combine

final class MapCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [MapRoute] = []
    private let artItemsInBoxService: ArtItemsInBoxService

    // MARK: - Lifecycle
    init(artItemsInBoxService: ArtItemsInBoxService) {
        self.artItemsInBoxService = artItemsInBoxService
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
            artItemsInBoxService: artItemsInBoxService
        )
        .build()
    }
    
    @ViewBuilder
        func destination(for route: MapRoute) -> some View {
            // TODO: - Coordinate to designated route
        }
}
