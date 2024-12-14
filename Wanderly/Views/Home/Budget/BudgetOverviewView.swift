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
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 16) {
                    // Header Section
                    HStack {
                        Text("Budget Overview")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Spacer()
                        NavigationLink(destination: ExpenseListView(trip: trip)) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
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
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("$\(trip.budget, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

                        Divider()

                        Text("Actual Spending")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("$\(totalExpenses, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(totalExpenses > trip.budget ? .red : .green)
                    }
                    .padding(.top, geometry.size.height * 0.05) // Adjust padding dynamically

//                    Spacer()
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
}
