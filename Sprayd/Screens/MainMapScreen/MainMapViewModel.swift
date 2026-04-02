//
//  MainMapViewModel.swift
//  Sprayd
//
//  Created by User on 01.04.2026.
//

import Foundation
import MapKit

@Observable
final class MainMapViewModel {
    var region: MKCoordinateRegion
    var markers: [MapMarker]

    init(
        region: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ),
        markers: [MapMarker] = [
            MapMarker(title: "Москва", latitude: 55.7558, longitude: 37.6176)
        ]
    ) {
        self.region = region
        self.markers = markers
    }
}
