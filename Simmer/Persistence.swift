//
//  Persistence.swift
//  Simmer
//
//  Created by Gabriel Groppo on 14/08/26.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: ModelContainer
    
    init(inMemory: Bool = false) {
        
        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: inMemory
        )
        
        do {
            
            container = try ModelContainer(
                for:
                    Receita.self,
                    Ingrediente.self,
                    Comentario.self,
                configurations: configuration
            )
            
        } catch {
            
            fatalError(
                "Não foi possível criar o ModelContainer: \(error)"
            )
        }
    }
}
