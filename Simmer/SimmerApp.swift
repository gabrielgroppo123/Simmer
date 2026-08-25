//
//  SimmerApp.swift
//  Simmer
//
//  Created by Gabriel Groppo on 13/08/26.
//

import SwiftUI
import SwiftData

@main
struct SimmerApp: App {
    
    let persistenceController = PersistenceController.shared
    
    let receitaService: ReceitaService
    
    @State private var mostrandoSplash = true
    
    init() {
        
        let context = PersistenceController.shared.container.mainContext
        
        self.receitaService = ReceitaService(
            repository: SwiftDataReceitaRepository(
                context: context
            )
        )
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            if mostrandoSplash {
                
                SplashView {
                    mostrandoSplash = false
                }
                
            } else {
                
                MainView(
                    service: receitaService
                )
            }
        }
        .modelContainer(
            persistenceController.container
        )
    }
}
