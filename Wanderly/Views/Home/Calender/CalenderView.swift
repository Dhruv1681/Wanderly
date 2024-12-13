//
//  CalenderView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 13/12/24.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        animation: .default
    ) private var trips: FetchedResults<Trip>

    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack {
            Text("Travel Calendar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            if trips.isEmpty {
                Text("No trips available.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                FSCalendarView(
                    selectedDate: $selectedDate,
                    tripDatesWithColors: fetchTripDatesWithColors()
                )
                .frame(height: 400) // Adjust height as needed

                ScrollView {
                    ForEach(trips, id: \Trip.objectID) { trip in
                        if isTripOnDate(trip: trip, date: selectedDate) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(trip.destination ?? "Unknown Location")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                if let startDate = trip.startDate, let endDate = trip.endDate {
                                    Text("\(formattedDate(startDate)) - \(formattedDate(endDate))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Dates not available")
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .padding()
    }

    // Fetch trip dates with colors
    private func fetchTripDatesWithColors() -> [(dates: [Date], color: UIColor)] {
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemPink]
        var tripDatesWithColors: [(dates: [Date], color: UIColor)] = []

        for (index, trip) in trips.enumerated() {
            guard let startDate = trip.startDate, let endDate = trip.endDate else { continue }
            let dateRange = Date.datesBetween(start: startDate, end: endDate)
            let color = colors[index % colors.count] // Cycle through colors
            tripDatesWithColors.append((dates: dateRange, color: color))
        }

        return tripDatesWithColors
    }

    // Check if a trip occurs on a given date
    private func isTripOnDate(trip: Trip, date: Date) -> Bool {
        guard let startDate = trip.startDate, let endDate = trip.endDate else { return false }
        return date >= startDate && date <= endDate
    }

    // Format date for display
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}


extension Date {
    static func datesBetween(start: Date, end: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = start
        let calendar = Calendar.current
        while currentDate <= end {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        return dates
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
