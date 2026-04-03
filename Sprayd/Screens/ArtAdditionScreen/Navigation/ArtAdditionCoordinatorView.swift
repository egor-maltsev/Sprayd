//
//  ArtAdditionCoordinatorView.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//


import SwiftUI

struct ArtAdditionCoordinatorView: View {
    @ObservedObject var coordinator: ArtAdditionCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeRootView()
                .navigationDestination(for: ArtAdditionRoute.self) { route in
                    coordinator.destination(for: route)
                }
        }
    }
}
