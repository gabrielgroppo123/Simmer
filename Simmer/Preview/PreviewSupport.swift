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
    
    static func criarReceitaPreview() -> ReceitaModel {
        
        let context =
            persistenceController.container.viewContext
        
        let receita = Receita(context: context)
        
        receita.id = UUID()
        receita.nome = "Salada Caesar"
        receita.categoria = "Legumes & vegetais"
        receita.favorito = false
        receita.dataCriacao = Date()
        receita.foto = Data()
        receita.porcoes = 2
        receita.duracao = 900
        receita.utensilios = String()
        receita.modoPreparo =
            "Misture todos os ingredientes."
        
        do {
            try context.save()
        } catch {
            fatalError(
                "Erro ao criar receita para Preview: \(error)"
            )
        }
        
        do {
            guard let receitaModel =
                    try receitaService.buscarReceita(
                        id: receita.id
                    ) else {
                
                fatalError(
                    "Receita de Preview não foi encontrada."
                )
            }
            
            return receitaModel
            
        } catch {
            
            fatalError(
                "Erro ao buscar receita de Preview: \(error)"
            )
        }
    }
    
    static func criarDadosObservacoesPreview() -> ReceitaModel {
        
        let context =
            persistenceController.container.viewContext
        
        let receita = Receita(context: context)
        
        receita.id = UUID()
        receita.nome = "Salada Caesar"
        receita.categoria = Categoria.saladasVegetais.rawValue
        receita.favorito = false
        receita.dataCriacao = Date()
        receita.foto = Data()
        receita.porcoes = 2
        receita.duracao = 900
        receita.utensilios = ""
        receita.modoPreparo = "Misture todos os ingredientes."
        
        let comentario1 = Comentario(context: context)
        
        comentario1.id = UUID()
        comentario1.descricao =
            "Fica excelente adicionando molho pesto de manjericão fresco."
        comentario1.data = Date()
        comentario1.receita = receita
        
        let comentario2 = Comentario(context: context)
        
        comentario2.id = UUID()
        comentario2.descricao =
            "Também funciona muito bem substituindo as nozes por castanhas."
        comentario2.data = Calendar.current.date(
            byAdding: .month,
            value: -2,
            to: Date()
        ) ?? Date()
        comentario2.receita = receita
        
        do {
            try context.save()
        } catch {
            fatalError(
                "Erro ao criar dados do Preview: \(error)"
            )
        }
        
        do {
            guard let receitaModel =
                    try receitaService.buscarReceita(
                        id: receita.id
                    ) else {
                fatalError("Receita do Preview não encontrada.")
            }
            
            return receitaModel
            
        } catch {
            fatalError(
                "Erro ao buscar receita do Preview: \(error)"
            )
        }
    }
}
