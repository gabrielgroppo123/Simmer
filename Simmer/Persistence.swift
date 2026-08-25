////
////  Persistence.swift
////  Simmer
////
////  Created by Gabriel Groppo on 13/08/26.
////
//
//import CoreData
//
//struct PersistenceController {
//    
//    static let shared = PersistenceController()
//    
//    @MainActor
//    static let preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        
//        return result
//    }()
//    
//    let container: NSPersistentContainer
//    
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "Simmer")
//        
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url =
//                URL(fileURLWithPath: "/dev/null")
//        }
//        
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//                fatalError(
//                    "Unresolved error \(error), \(error.userInfo)"
//                )
//            }
//        }
//        
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//}

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
