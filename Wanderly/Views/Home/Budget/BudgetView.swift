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
                
                NavigationLink(destination: AddExpenseView(trip: trip)) {
                    Text("Add Expense")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            } else {
                Text("Please select a trip")
                    .font(.title2)
                    .padding()
                
                // Display upcoming trips to select from
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(upcomingTrips, id: \.objectID) { trip in
                            VStack {
                                Text(trip.destination ?? "Unknown Destination")
                                    .font(.headline)
                                Text(formattedDateRange(start: trip.startDate, end: trip.endDate))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    selectedTrip = trip
                                    print("Selected trip: \(trip.destination ?? "Unknown")") // Debug log
                                }) {
                                    Text("Select")
                                        .foregroundColor(.blue)
                                        .padding(.top, 5)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal)
                }
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


//struct BudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create an in-memory Core Data context for the preview
//        let context = PersistenceController.preview.container.viewContext
//        let sampleTrip = Trip(context: context)
//        sampleTrip.destination = "Sample Destination"
//        sampleTrip.startDate = Date()
//        sampleTrip.endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
//        sampleTrip.budget = 1000.0
//        sampleTrip.notes = "Sample notes"
//        sampleTrip.id = UUID()
//        
//        return NavigationView {
//            BudgetView()
//                .environment(\.managedObjectContext, context)
//        }
//    }
//}
