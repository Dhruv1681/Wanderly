//
//  TripExpense+CoreDataProperties.swift
//  Wanderly
//
//  Created by Dhruv Soni on 11/12/24.
//
//

import Foundation
import CoreData


extension TripExpense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripExpense> {
        return NSFetchRequest<TripExpense>(entityName: "TripExpense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var trip: Trip?

}
