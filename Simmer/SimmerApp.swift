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
    
    let receitaService = ReceitaService(
        repository: CoreDataReceitaRepository(
            context: PersistenceController.shared.container.viewContext
        )
    )
    
    @State private var mostrandoSplash = true
    
    var body: some Scene {
        WindowGroup {
            MainView(service: receitaService)
        }
    }
}
