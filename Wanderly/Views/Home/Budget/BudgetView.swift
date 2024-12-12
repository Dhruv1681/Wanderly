//
//  BudgetView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 11/12/24.
//

import SwiftUI

struct BudgetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        predicate: NSPredicate(format: "startDate >= %@", Date() as NSDate), // Fetch only upcoming trips
        animation: .default
    ) private var upcomingTrips: FetchedResults<Trip>
    
    @State private var selectedTrip: Trip?
    
    var body: some View {
        VStack {
            if let trip = selectedTrip {
                BudgetOverviewView(trip: trip)
                    .padding(.vertical, 20)
                
                NavigationLink(destination: AddExpenseView(trip: trip)) {
                    Text("Add Expense")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .shadow(radius: 5)
            } else {
                Text("Please select a trip")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(upcomingTrips, id: \.objectID) { trip in
                        TripCardView(trip: trip, isSelected: trip == selectedTrip)
                            .onTapGesture {
                                selectedTrip = trip
                                print("Selected trip: \(trip.destination ?? "Unknown")") // Debug log
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Budget")
        .onAppear {
            print("Upcoming trips count: \(upcomingTrips.count)") // Debug log to check if trips are fetched
        }
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

struct TripCardView: View {
    let trip: Trip
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(trip.destination ?? "Unknown Destination")
                .font(.headline)
                .foregroundColor(isSelected ? .white : .primary)
            
            Text(formattedDateRange(start: trip.startDate, end: trip.endDate))
                .font(.subheadline)
                .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
            
            Spacer()
            
            if isSelected {
                Text("Selected")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.top, 5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.blue : Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .animation(.easeInOut, value: isSelected)
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
