//
//  SimmerApp.swift
//  Simmer
//
//  Created by Gabriel Groppo on 13/08/26.
//

import SwiftUI
import CoreData

@main
struct SimmerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
