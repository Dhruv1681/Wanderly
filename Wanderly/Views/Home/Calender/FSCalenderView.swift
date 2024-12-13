//
//  FSCalenderView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 13/12/24.
//

import SwiftUI
import FSCalendar

// FSCalendarView.swift
import SwiftUI
import FSCalendar

struct FSCalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    var tripDatesWithColors: [(dates: [Date], color: UIColor)] // Trip dates with associated colors

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator

        // Customization
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 16)
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 14)
        calendar.appearance.todayColor = UIColor.systemRed
        calendar.appearance.selectionColor = UIColor.systemBlue

        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: FSCalendarView

        init(_ parent: FSCalendarView) {
            self.parent = parent
        }

        // Highlighted dates with different colors
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
            for (dates, color) in parent.tripDatesWithColors {
                if dates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                    return color
                }
            }
            return nil
        }

        // Handle date selection
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
    }
}
