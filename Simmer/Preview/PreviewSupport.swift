//
//  PreviewSupport.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation
import SwiftData

@MainActor
enum PreviewSupport {
    
    static let persistenceController =
        PersistenceController(inMemory: true)
    
    static let receitaService = ReceitaService(
        repository: SwiftDataReceitaRepository(
            context: persistenceController.container.mainContext))
    
    static func criarReceitaPreview() -> ReceitaModel {
        
        let context = persistenceController.container.mainContext
        
        let receita = Receita(
            nome: "Salada Caesar",
            categoria: "Legumes & vegetais",
            favorito: false,
            dataCriacao: Date(),
            foto: Data(),
            porcoes: 2,
            duracao: 900,
            utensilios: "",
            modoPreparo: "Misture todos os ingredientes.")
        
        context.insert(receita)
        
        do {
            
            try context.save()
            
        } catch {
            
            fatalError("Erro ao criar receita para Preview: \(error)")
        }
        
        do {
            
            guard let receitaModel = try receitaService.buscarReceita(id: receita.id)
            else {
                
                fatalError("Receita de Preview não foi encontrada.")
            }
            
            return receitaModel
            
        } catch {
            
            fatalError("Erro ao buscar receita de Preview: \(error)")
        }
    }
    static func criarDadosObservacoesPreview() -> ReceitaModel {
        
        let context = persistenceController.container.mainContext
        
        let receita = Receita(
            nome: "Salada Caesar",
            categoria: Categoria.saladasVegetais.rawValue,
            favorito: false,
            dataCriacao: Date(),
            foto: Data(),
            porcoes: 2,
            duracao: 900,
            utensilios: "",
            modoPreparo:
                "Misture todos os ingredientes.")
        
        context.insert(receita)
        
        let comentario1 = Comentario(
            descricao: "Fica excelente adicionando molho pesto de manjericão fresco.",
            data: Date(),
            receita: receita
        )
        
        let comentario2 = Comentario(
            descricao: "Também funciona muito bem substituindo as nozes por castanhas.",
            data: Calendar.current.date(byAdding: .month,value: -2,to: Date()) ?? Date(),
            receita: receita)
        
        context.insert(comentario1)
        context.insert(comentario2)
        
        receita.comentarios.append(comentario1)
        receita.comentarios.append(comentario2)
        
        do {
            
            try context.save()
            
        } catch {
            
            fatalError("Erro ao criar dados do Preview: \(error)")
        }
        
        do {
            
            guard let receitaModel = try receitaService.buscarReceita(id: receita.id)
            else {
                
                fatalError("Receita do Preview não encontrada.")
            }
            
            return receitaModel
            
        } catch {
            
            fatalError("Erro ao buscar receita do Preview: \(error)")
        }
    }
}
