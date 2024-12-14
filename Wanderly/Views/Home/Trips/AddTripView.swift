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
        NavigationView {
            Form {
                // Trip Details Section
                Section(header: Text("Trip Details")
                            .font(.headline)
                            .foregroundColor(.blue)) {
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.blue)
                        TextField("Destination", text: $destination)
                            .autocapitalization(.words)
                    }

                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .accentColor(.blue)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .accentColor(.blue)

                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.green)
                        TextField("Budget", text: $budget)
                            .keyboardType(.decimalPad)
                    }
                }

                // Notes Section
                Section(header: Text("Additional Notes")
                            .font(.headline)
                            .foregroundColor(.blue)) {
                    HStack(alignment: .top) {
                        Image(systemName: "pencil.tip")
                            .foregroundColor(.orange)
                        TextField("Notes (Optional)", text: $notes)
                    }
                }

                // Save Button Section
                Section {
                    Button(action: saveTrip) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text(existingTrip == nil ? "Add Trip" : "Update Trip")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            .navigationTitle(existingTrip == nil ? "Add Trip" : "Edit Trip")
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    private func saveTrip() {
        guard !destination.isEmpty else {
            alertMessage = "Please enter a destination."
            showAlert = true
            return
        }

        guard endDate >= startDate else {
            alertMessage = "End date must be after the start date."
            showAlert = true
            return
        }

        guard let budgetValue = Double(budget), budgetValue >= 0 else {
            alertMessage = "Please enter a valid budget."
            showAlert = true
            return
        }

        if existingTrip == nil {
            let newTrip = Trip(context: viewContext)
            newTrip.destination = destination
            newTrip.startDate = startDate
            newTrip.endDate = endDate
            newTrip.budget = budgetValue
            newTrip.notes = notes
            newTrip.id = UUID()
        } else {
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
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
