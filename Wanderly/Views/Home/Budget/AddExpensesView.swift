//
//  AddExpensesView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 11/12/24.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var trip: Trip

    @State private var category = ""
    @State private var amount: String = ""
    @State private var note = ""

    var body: some View {
        Form {
            TextField("Category", text: $category)
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
            TextField("Note (Optional)", text: $note)
        }
        .navigationTitle("Add Expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveExpense()
                }
            }
        }
    }

    private func saveExpense() {
        guard !category.isEmpty, let expenseAmount = Double(amount) else { return }

        let expense = TripExpense(context: viewContext)
        expense.category = category
        expense.amount = expenseAmount
        expense.note = note
        expense.date = Date()
        expense.trip = trip

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
        }
    }
}

struct AddExpense_Preview: PreviewProvider {
    static var previews: some View {
        // Create an in-memory Core Data context for the preview
        let context = PersistenceController.preview.container.viewContext
        let sampleTrip = Trip(context: context)
        sampleTrip.destination = "Sample Destination"
        sampleTrip.startDate = Date()
        sampleTrip.endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        sampleTrip.budget = 1000.0
        sampleTrip.notes = "Sample notes"
        sampleTrip.id = UUID()

        return AddExpenseView(trip: sampleTrip)
            .environment(\.managedObjectContext, context)
    }
}
