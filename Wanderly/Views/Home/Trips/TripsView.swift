//
//  TripsView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 10/12/24.
//

import SwiftUI

struct TripsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Trip.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        animation: .default
    ) private var trips: FetchedResults<Trip>

    @State private var refreshID = UUID()

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                if trips.isEmpty {
                    // Empty State
                    VStack {
                        Image(systemName: "airplane")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        Text("No Trips Added Yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding()
                        NavigationLink(destination: AddTripView()
                                        .environment(\.managedObjectContext, viewContext)) {
                            Text("Add Your First Trip")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.horizontal, 50)
                        }
                    }
                } else {
                    // List of Trips
                    List {
                        ForEach(trips, id: \.id) { trip in
                            NavigationLink(destination: AddTripView(existingTrip: trip)
                                            .environment(\.managedObjectContext, viewContext)) {
                                TripCardView(trip: trip)
                            }
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: deleteTrips)
                    }
                    .id(refreshID)
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Trips")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: AddTripView()
                                    .environment(\.managedObjectContext, viewContext)) {
                        Label("Add Trip", systemImage: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                refreshID = UUID()
                printDestinations()
            }
        }
    }

    private func printDestinations() {
        for trip in trips {
            print("Destination: \(trip.destination ?? "Unknown")")
        }
    }

    private func deleteTrips(offsets: IndexSet) {
        withAnimation {
            offsets.map { trips[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting trip: \(error.localizedDescription)")
            }
        }
    }
}

struct TripCardView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(trip.destination ?? "Unknown Destination")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text("\(formattedDate(trip.startDate)) - \(formattedDate(trip.endDate))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Budget: $\(trip.budget, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensures full-width cards
        .background(
//            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal) // Adds consistent horizontal spacing to the edges
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView().previewDevice("iPhone 14")
    }
}
