//
//  LocationPickerView.swift
//  Sprayd
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    var onConfirm: (CLLocationCoordinate2D) -> Void

    var body: some View {
        NavigationStack {
            MapReader { proxy in
                Map(position: $position) {
                    if let selectedCoordinate {
                        Marker("Selected", coordinate: selectedCoordinate)
                            .tint(Color.accentRed)
                    }
                }
                .onTapGesture { screenPoint in
                    if let coordinate = proxy.convert(screenPoint, from: .local) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCoordinate = coordinate
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Pick location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let selectedCoordinate {
                            onConfirm(selectedCoordinate)
                        }
                        dismiss()
                    }
                    .disabled(selectedCoordinate == nil)
                }
            }
        }
    }
}
