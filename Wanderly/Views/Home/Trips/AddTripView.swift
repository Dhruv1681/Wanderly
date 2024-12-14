//
//  AddTripView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 08/12/24.
//

import SwiftUI
import CoreData

struct AddTripView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var budget: String = ""
    @State private var notes = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

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
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    private func saveTrip() {
        guard !destination.isEmpty else {
            alertMessage = "Please fill in all required fields"
            showAlert = true
            return
        }
        
        guard endDate >= startDate else {
            alertMessage = "End date must be later than start date."
            showAlert = true
            return
        }

        guard let budgetValue = Double(budget), budgetValue >= 0 else {
            alertMessage = "Please enter a valid budget."
            showAlert = true
            return
        }

        // Prevent setting trips for past dates
        if startDate < Date() {
            alertMessage = "Start date cannot be in the past."
            showAlert = true
            return
        }

        // Check for overlapping trips
        if isOverlappingTrip() {
            alertMessage = "This trip overlaps with an existing trip."
            showAlert = true
            return
        }

        // If no issues, save the trip
        if existingTrip == nil {
            // Create a new trip if none exists
            let newTrip = Trip(context: viewContext)
            newTrip.destination = destination
            newTrip.startDate = startDate
            newTrip.endDate = endDate
            newTrip.budget = budgetValue
            newTrip.notes = notes
        } else {
            // Update the existing trip
            existingTrip?.destination = destination
            existingTrip?.startDate = startDate
            existingTrip?.endDate = endDate
            existingTrip?.budget = budgetValue
            existingTrip?.notes = notes
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving trip: \(error.localizedDescription)")
        }
    }

    private func isOverlappingTrip() -> Bool {
        // Fetch all trips from the database
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        let currentTrips: [Trip]
        
        do {
            currentTrips = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching trips: \(error.localizedDescription)")
            return false
        }

        // Check for overlapping dates with existing trips
        for trip in currentTrips {
            if let existingStart = trip.startDate, let existingEnd = trip.endDate {
                // If the new trip overlaps with any existing trip, return true
                if (startDate <= existingEnd && endDate >= existingStart) {
                    return true
                }
            }
        }
        
        return false
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
