
//
//  Untitled.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import CoreData

enum PreviewSupport {
    
    static let persistenceController = PersistenceController(
        inMemory: true
    )
    
    static let receitaService = ReceitaService(
        repository: CoreDataReceitaRepository(
            context: persistenceController.container.viewContext
        )
    )
}
