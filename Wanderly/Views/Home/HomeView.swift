//
//  HomeView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 02/12/24.
//

import SwiftUI
import MapKit

@MainActor
struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        predicate: NSPredicate(format: "startDate >= %@", Date() as NSDate), // Fetch only upcoming trips
        animation: .default
    ) private var upcomingTrips: FetchedResults<Trip>
    
    @State private var isLoggedIn = true // Track authentication status
    @State private var weatherData: CurrentWeather? // State to hold the weather data
    @State private var coordinates: CLLocationCoordinate2D? // State for coordinates
    @State private var weatherService = WeatherService() // WeatherService instance
    @State private var selectedTrip: Trip? // Track the selected trip

    var body: some View {
        if isLoggedIn {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Welcome Header
                    Text("Dashboard")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Quick Access Cards
                    HStack(spacing: 15) {
                        NavigationLink(destination: TripsView()) {
                            FeatureCard(title: "My Trips", iconName: "airplane")
                        }
                        NavigationLink(destination: CalendarView()) {
                            FeatureCard(title: "Calendar", iconName: "calendar")
                        }
                        NavigationLink(destination: BudgetView()) {
                            FeatureCard(title: "Budget", iconName: "creditcard")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Upcoming Trips Section
                    Text("Upcoming Trips")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if upcomingTrips.isEmpty {
                        Text("No upcoming trips")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(upcomingTrips, id: \.objectID) { trip in
                                    TripCard(
                                        destination: trip.destination ?? "Unknown Destination",
                                        date: formattedDateRange(start: trip.startDate, end: trip.endDate)
                                    )
                                    .onTapGesture {
                                        selectTrip(trip) // Handle trip selection
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Show weather and map for the selected trip
                        if let selectedTrip = selectedTrip, let destination = selectedTrip.destination {
                            Text("Weather in \(destination)")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if let weather = weatherData {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Temperature:")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            Text("\(weather.temp_c, specifier: "%.1f")°C")
                                                .font(.title)
                                                .fontWeight(.bold)
                                        }
                                        
                                        Spacer()
                                        
                                        if let iconURL = weather.condition.iconURL {
                                            AsyncImage(url: iconURL) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    }
                                    
                                    Text("Condition: \(weather.condition.description.capitalized)")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                                .padding(.horizontal)
                            } else {
                                Text("Loading weather data...")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            }
                            
                            // Map View with Coordinates
                            MapView(destination: destination) // Pass the destination string here
                                .frame(height: 150)
                                .padding(.horizontal)
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                                .onAppear {
                                    fetchCoordinates(for: destination)
                                }
                        }
                    }
                    
                    Spacer()
                    
                    // Add Trip Button
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddTripView()) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Trip")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                }
                .onAppear {
                    if let firstTrip = upcomingTrips.first {
                        selectTrip(firstTrip) // Automatically select the first trip
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout") {
                            logout()
                        }
                    }
                }
            }
        } else {
            LoginView() // Navigate to LoginView if not logged in
        }
    }

    private func logout() {
        isLoggedIn = false // Update the state to navigate back to LoginView
    }

    private func formattedDateRange(start: Date?, end: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"

        if let start = start, let end = end {
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        } else {
            return "N/A"
        }
    }

    private func fetchWeatherForSelectedTrip() {
        guard let selectedTrip = selectedTrip,
              let destination = selectedTrip.destination else { return }

        weatherService.fetchWeather(for: destination) { weather in
            DispatchQueue.main.async {
                self.weatherData = weather
            }
        }
    }

    private func fetchCoordinates(for destination: String) {
        weatherService.fetchCoordinates(for: destination) { fetchedCoordinates in
            DispatchQueue.main.async {
                if let coordinates = fetchedCoordinates {
                    self.coordinates = coordinates
                } else {
                    print("Failed to fetch coordinates for \(destination)")
                }
            }
        }
    }

    private func selectTrip(_ trip: Trip) {
        selectedTrip = trip
        fetchWeatherForSelectedTrip() // Fetch weather data for the selected trip
    }
}

// Reusable FeatureCard Component
struct FeatureCard: View {
    var title: String
    var iconName: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(.blue)
            Text(title)
                .padding(1)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(width: 100, height: 100)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

// Reusable TripCard Component
struct TripCard: View {
    var destination: String
    var date: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(destination)
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.bottom, 3)
            Text(date)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 180, height: 100)
//        .background(Color(UIColor.systemBackground))
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue.opacity(0.6), lineWidth: 1)
        )
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
