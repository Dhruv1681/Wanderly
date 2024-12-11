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
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        animation: .default
    ) private var trips: FetchedResults<Trip>

    @State private var isAddingTrip = false
    @State private var editingTrip: Trip? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(trips) { trip in
                    NavigationLink(destination: AddTripView(existingTrip: trip)
                                    .environment(\.managedObjectContext, viewContext)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(trip.destination ?? "Unknown Destination")
                                    .font(.headline)
                                Text("\(formattedDate(trip.startDate)) - \(formattedDate(trip.endDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Budget: $\(trip.budget, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: deleteTrips)
            }
            .navigationTitle("My Trips")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: AddTripView()
                                    .environment(\.managedObjectContext, viewContext)) {
                        Label("Add Trip", systemImage: "plus")
                    }
                }
            }
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

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
    }
}
