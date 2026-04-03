//
//  ArtAdditionCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//


import SwiftUI
internal import Combine

final class ArtAdditionCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [ArtAdditionRoute] = []
    
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
        ArtAdditionView(onBackButtonTapped: {})
    }
    
    @ViewBuilder
        func destination(for route: ArtAdditionRoute) -> some View {
            // TODO: - Coordinate to designated route
        }
}
