//
//  ExpenseListView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 12/12/24.
//

import SwiftUI

struct ExpenseListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var trip: Trip
    @FetchRequest private var expenses: FetchedResults<TripExpense>
    @State private var selectedExpense: TripExpense?

    init(trip: Trip) {
        self.trip = trip
        self._expenses = FetchRequest(
            entity: TripExpense.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TripExpense.date, ascending: true)],
            predicate: NSPredicate(format: "trip == %@", trip)
        )
    }

    var body: some View {
        VStack {
            List {
                ForEach(expenses, id: \.self) { expense in
                    VStack(alignment: .leading) {
                        Text(expense.category ?? "Unknown Category")
                            .font(.headline)
                        Text("Amount: $\(expense.amount, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        if let note = expense.note, !note.isEmpty {
                            Text("Note: \(note)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Text("Date: \(expense.date ?? Date(), formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                    .swipeActions {
                        Button("Edit") {
                            selectedExpense = expense // Set the selected expense
                        }
                        .tint(.yellow)

                        Button("Delete") {
                            deleteExpense(expense)
                        }
                        .tint(.red)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Expenses")
        .navigationDestination(isPresented: .constant(selectedExpense != nil)) {
            if let selectedExpense {
                ExpenseEditView(expense: selectedExpense)
                    .onDisappear {
                        // Clear the selected expense when we return to the list
                        self.selectedExpense = nil
                    }
            }
        }
    }

    private func deleteExpense(_ expense: TripExpense) {
        viewContext.delete(expense)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting expense: \(error.localizedDescription)")
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
