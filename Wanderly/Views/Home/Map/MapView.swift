//
//  MapView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 13/12/24.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    var destination: String
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0), // Default to (0,0)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var locations: [Location] = []
    @State private var isLoading = true // Loading state

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapMarker(coordinate: location.coordinate, tint: .blue)
            }
            .ignoresSafeArea()

            if isLoading {
                ProgressView("Loading map...")
            }
        }
        .onAppear {
            fetchCoordinates(for: destination)
        }
    }
    
    private func fetchCoordinates(for destination: String) {
        let weatherService = WeatherService()
        weatherService.fetchCoordinates(for: destination) { fetchedCoordinates in
            DispatchQueue.main.async {
                isLoading = false
                if let coordinates = fetchedCoordinates {
                    region.center = coordinates // Update map center
                    locations = [Location(coordinate: coordinates)] // Add marker
                } else {
                    print("Failed to fetch coordinates for \(destination)")
                }
            }
        }
    }
}
