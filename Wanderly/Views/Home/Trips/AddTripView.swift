//
//  AddTripView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 08/12/24.
//

import SwiftUI

struct AddTripView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var budget: String = ""
    @State private var notes = ""

    @State private var showAlert = false

    var existingTrip: Trip?

    init(existingTrip: Trip? = nil) {
        self.existingTrip = existingTrip
        _destination = State(initialValue: existingTrip?.destination ?? "")
        _startDate = State(initialValue: existingTrip?.startDate ?? Date())
        _endDate = State(initialValue: existingTrip?.endDate ?? Date())
        _budget = State(initialValue: existingTrip?.budget != nil ? String(existingTrip!.budget) : "")
        _notes = State(initialValue: existingTrip?.notes ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("Trip Details")) {
                TextField("Destination", text: $destination)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                TextField("Budget", text: $budget)
                    .keyboardType(.decimalPad)
                TextField("Notes (Optional)", text: $notes)
            }
        }
        .navigationTitle(existingTrip == nil ? "Add Trip" : "Edit Trip")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveTrip()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .alert("Please fill in all required fields", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    private func saveTrip() {
        guard !destination.isEmpty else {
            showAlert = true
            return
        }
        
        guard endDate >= startDate else {
            showAlert = true
            return
        }

        guard let budgetValue = Double(budget), budgetValue >= 0 else {
            showAlert = true
            return
        }

        let trip = existingTrip ?? Trip(context: viewContext)
        trip.destination = destination
        trip.startDate = startDate
        trip.endDate = endDate
        trip.budget = budgetValue
        trip.notes = notes

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving trip: \(error.localizedDescription)")
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
