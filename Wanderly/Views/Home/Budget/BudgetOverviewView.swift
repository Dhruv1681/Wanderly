//
//  BudgetOverviewView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 11/12/24.
//

import SwiftUI

struct BudgetOverviewView: View {
    var trip: Trip

    var totalExpenses: Double {
        trip.expenses?.compactMap { ($0 as? TripExpense)?.amount }.reduce(0, +) ?? 0
    }

    var body: some View {
        VStack {
            Text("Budget Overview")
                .font(.headline)
            Text("Planned Budget: $\(trip.budget, specifier: "%.2f")")
            Text("Actual Spending: $\(totalExpenses, specifier: "%.2f")")
                .foregroundColor(totalExpenses > trip.budget ? .red : .green)
        }
        .padding()
    }
}


struct Budget_Previews: PreviewProvider {
    static var previews: some View {
        // Create an in-memory Core Data context for the preview
        let context = PersistenceController.preview.container.viewContext
        
        // Create a sample Trip for the preview
        let sampleTrip = Trip(context: context)
        sampleTrip.destination = "Sample Destination"
        sampleTrip.startDate = Date()
        sampleTrip.endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        sampleTrip.budget = 1000.0
        sampleTrip.notes = "Sample notes"
        sampleTrip.id = UUID()

        return BudgetOverviewView(trip: sampleTrip)
            .environment(\.managedObjectContext, context)
    }
}
