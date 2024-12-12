//
//  BudgetOverviewView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 11/12/24.
//

import SwiftUI

struct BudgetOverviewView: View {
    @ObservedObject var trip: Trip
    @FetchRequest private var expenses: FetchedResults<TripExpense>
    @State private var showExpenseList = false

    init(trip: Trip) {
        self.trip = trip
        self._expenses = FetchRequest(
            entity: TripExpense.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TripExpense.date, ascending: true)],
            predicate: NSPredicate(format: "trip == %@", trip)
        )
    }

    var totalExpenses: Double {
        expenses.map { $0.amount }.reduce(0, +)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                HStack {
                    Text("Budget Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        showExpenseList.toggle()
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.blue)
                            Text("View Expenses")
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                    }
                }

                // Budget Data Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Planned Budget")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$\(trip.budget, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    Divider()

                    Text("Actual Spending")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$\(totalExpenses, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(totalExpenses > trip.budget ? .red : .green)
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .navigationDestination(isPresented: $showExpenseList) {
                ExpenseListView(trip: trip)
            }
        }
        .background(Color(UIColor.systemGroupedBackground)) // Light background color
        .cornerRadius(15)
        .shadow(radius: 4) // Soft shadow effect for a more elevated look
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
