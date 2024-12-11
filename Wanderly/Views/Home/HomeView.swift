//
//  HomeView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 02/12/24.
//

import SwiftUI

@MainActor
struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        predicate: NSPredicate(format: "startDate >= %@", Date() as NSDate), // Fetch only upcoming trips
        animation: .default
    ) private var upcomingTrips: FetchedResults<Trip>
    
    @State private var isLoggedIn = true // Track authentication status

    var body: some View {
        if isLoggedIn {
            VStack(alignment: .leading, spacing: 20) {
                // Welcome Header
                Text("Welcome back, Dhruv!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Quick Access Cards
                HStack(spacing: 15) {
                    NavigationLink(destination: TripsView()) {
                        FeatureCard(title: "My Trips", iconName: "airplane")
                    }
                    NavigationLink(destination: Text("Calendar View Placeholder")) {
                        FeatureCard(title: "Calendar", iconName: "calendar")
                    }
                    NavigationLink(destination: Text("Budget Planner Placeholder")) {
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
                        HStack(spacing: 55) {
                            ForEach(upcomingTrips) { trip in
                                TripCard(
                                    destination: trip.destination ?? "Unknown Destination",
                                    date: formattedDateRange(start: trip.startDate, end: trip.endDate)
                                )
                            }
                        }
                        .padding(.horizontal)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        logout()
                    }
                }
            }
        } else {
            LoginView() // Navigate to LoginView if not logged in
        }
    }

    private func logout() {
        // Clear any saved authentication tokens or user data here
        isLoggedIn = false // Update the state to navigate back to LoginView
    }

    private func formattedDateRange(start: Date?, end: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        if let start = start, let end = end {
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        } else {
            return "N/A"
        }
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
                .fontWeight(.bold)
            Text(date)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 150, height: 100)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
