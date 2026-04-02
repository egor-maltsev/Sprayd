//
//  MapView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import MapKit

struct UIKitMapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let markers: [MapMarker]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateRegion(for: uiView)
        updateAnnotations(for: uiView)
    }

    func makeCoordinator() -> UIKitMapCoordinator {
        UIKitMapCoordinator()
    }

    private func updateRegion(for mapView: MKMapView) {
        if mapView.region.center.latitude != region.center.latitude ||
           mapView.region.center.longitude != region.center.longitude ||
           mapView.region.span.latitudeDelta != region.span.latitudeDelta ||
           mapView.region.span.longitudeDelta != region.span.longitudeDelta {
            mapView.setRegion(region, animated: true)
        }
    }

    private func updateAnnotations(for mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)

        let annotations = markers.map { marker in
            let annotation = MKPointAnnotation()
            annotation.title = marker.title
            annotation.coordinate = marker.coordinate
            return annotation
        }

        mapView.addAnnotations(annotations)
    }
}
