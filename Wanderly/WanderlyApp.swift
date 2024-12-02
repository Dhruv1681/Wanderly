//
//  WanderlyApp.swift
//  Wanderly
//
//  Created by Dhruv Soni on 02/12/24.
//

import SwiftUI

@main
struct WanderlyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
