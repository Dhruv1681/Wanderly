//
//  Trip+CoreDataProperties.swift
//  Wanderly
//
//  Created by Dhruv Soni on 10/12/24.
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
    @NSManaged public var notes: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var id: UUID?

}

extension Trip : Identifiable {

}
