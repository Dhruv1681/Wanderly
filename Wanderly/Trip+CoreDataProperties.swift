//
//  Trip+CoreDataProperties.swift
//  Wanderly
//
//  Created by Dhruv Soni on 11/12/24.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var budget: Double
    @NSManaged public var destination: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var expenses: NSSet?

    public var identifiableID: NSManagedObjectID {
        return self.objectID
    }
}

// MARK: Generated accessors for expenses
extension Trip {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: TripExpense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: TripExpense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}
