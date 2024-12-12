//
//  EditExpenseView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 12/12/24.
//

import SwiftUI

struct ExpenseEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var expense: TripExpense
    @State private var amount: Double
    @State private var category: String
    @State private var note: String

    init(expense: TripExpense) {
        self.expense = expense
        _amount = State(initialValue: expense.amount)
        _category = State(initialValue: expense.category ?? "")
        _note = State(initialValue: expense.note ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                TextField("Category", text: $category)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
                TextField("Note", text: $note)
            }

            Section {
                Button("Save") {
                    saveExpense()
                }
                .disabled(category.isEmpty || amount <= 0)
            }
        }
        .navigationTitle("Edit Expense")
    }

    private func saveExpense() {
        expense.amount = amount
        expense.category = category
        expense.note = note

        do {
            try viewContext.save()
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
        }
    }
}
