//
//  MainMapView.swift
//  Sprayd
//
//  Created by User on 02.04.2026.
//

import SwiftUI

struct MainMapView: View {
    @State private var viewModel = MainMapViewModel()

    var body: some View {
        UIKitMapView(
            region: viewModel.region,
            markers: viewModel.markers
        )
        .ignoresSafeArea()
    }
}
