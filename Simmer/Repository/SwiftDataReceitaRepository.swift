//
//  SwiftDataReceitaRepository.swift
//  Simmer
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 25/08/26.
//

//
//  SwiftDataReceitaRepository.swift
//  Simmer
//
//  Created by Gabriel Groppo on 24/08/26.
//


import Foundation
import SwiftData

@MainActor
final class SwiftDataReceitaRepository: ReceitaRepository {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
   
    func criarReceita(
        _ dados: NovaReceita
    ) throws -> ReceitaModel {
        
        let receita = Receita(
            nome: dados.nome,
            categoria: dados.categoria.rawValue,
            favorito: false,
            dataCriacao: Date(),
            foto: dados.foto,
            porcoes: dados.porcoes ?? 1,
            duracao: dados.duracao,
            utensilios: dados.utensilios,
            modoPreparo: dados.modoPreparo
        )
        
        context.insert(receita)
        
        for dadosIngrediente in dados.ingredientes {
            
            let ingrediente = Ingrediente(
                nome: dadosIngrediente.nome,
                quantidade: dadosIngrediente.quantidade,
                unidade: dadosIngrediente.unidade.rawValue,
                receita: receita
            )
            
            context.insert(ingrediente)
            receita.ingredientes.append(ingrediente)
        }
        
        try context.save()
        
        return converterReceita(receita)
    }
    
   
    func buscarReceitas() throws -> [ReceitaModel] {
        
        let descriptor = FetchDescriptor<Receita>()
        
        let receitas = try context.fetch(
            descriptor
        )
        
        let receitasOrdenadas = receitas.sorted {
            ($0.dataCriacao ?? .distantPast)
            >
            ($1.dataCriacao ?? .distantPast)
        }
        
        return receitasOrdenadas.map {
            converterReceita($0)
        }
    }
   
    func buscarReceitas(
        texto: String
    ) throws -> [ReceitaModel] {
        
        let descriptor = FetchDescriptor<Receita>()
        
        let receitas = try context.fetch(
            descriptor
        )
        
        let textoNormalizado = texto
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        let receitasFiltradas: [Receita]
        
        if textoNormalizado.isEmpty {
            
            receitasFiltradas = receitas
            
        } else {
            
            receitasFiltradas = receitas.filter {
                $0.nome.localizedCaseInsensitiveContains(
                    textoNormalizado
                )
            }
        }
        
        let receitasOrdenadas = receitasFiltradas.sorted {
            ($0.dataCriacao ?? .distantPast)
            >
            ($1.dataCriacao ?? .distantPast)
        }
        
        return receitasOrdenadas.map {
            converterReceita($0)
        }
    }
    
    func buscarReceita(
        id: UUID
    ) throws -> ReceitaModel? {
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: #Predicate {
                $0.id == id
            }
        )
        
        guard let receita = try context.fetch(
            descriptor
        ).first else {
            return nil
        }
        
        return converterReceita(receita)
    }
    
    func atualizarReceita(
        _ receita: ReceitaModel,
        nome: String,
        categoria: Categoria,
        foto: Data,
        porcoes: Int16?,
        duracao: Int64,
        utensilios: String?,
        modoPreparo: String,
        ingredientes: [NovoIngrediente]
    ) throws {
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: #Predicate {
                $0.id == receita.id
            }
        )
        
        guard let receitaSwiftData = try context.fetch(
            descriptor
        ).first else {
            
            return
        }
        
        receitaSwiftData.nome = nome
        receitaSwiftData.categoria = categoria.rawValue
        receitaSwiftData.foto = foto
        receitaSwiftData.porcoes = porcoes ?? 1
        receitaSwiftData.duracao = duracao
        receitaSwiftData.utensilios = utensilios
        receitaSwiftData.modoPreparo = modoPreparo
        
       
        for ingrediente in receitaSwiftData.ingredientes {
            context.delete(ingrediente)
        }
        
        receitaSwiftData.ingredientes.removeAll()
        
       
        for dadosIngrediente in ingredientes {
            
            let ingrediente = Ingrediente(
                nome: dadosIngrediente.nome,
                quantidade: dadosIngrediente.quantidade,
                unidade: dadosIngrediente.unidade.rawValue,
                receita: receitaSwiftData
            )
            
            context.insert(ingrediente)
            receitaSwiftData.ingredientes.append(
                ingrediente
            )
        }
        
        try context.save()
    }
    
    
    func atualizarFavorito(
        _ receita: ReceitaModel,
        favorito: Bool
    ) throws {
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: #Predicate {
                $0.id == receita.id
            }
        )
        
        guard let receitaSwiftData = try context.fetch(
            descriptor
        ).first else {
            
            return
        }
        
        receitaSwiftData.favorito = favorito
        
        try context.save()
    }
    
 
    func deletarReceita(
        _ receita: ReceitaModel
    ) throws {
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: #Predicate {
                $0.id == receita.id
            }
        )
        
        guard let receitaSwiftData = try context.fetch(
            descriptor
        ).first else {
            
            return
        }
        
        context.delete(receitaSwiftData)
        
        try context.save()
    }
    
 
    func criarComentario(
        descricao: String,
        receita: ReceitaModel
    ) throws -> ComentarioModel {
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: #Predicate {
                $0.id == receita.id
            }
        )
        
        guard let receitaSwiftData = try context.fetch(
            descriptor
        ).first else {
            
            throw NSError(
                domain: "Simmer",
                code: 404,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "A receita não foi encontrada no SwiftData."
                ]
            )
        }
        
        let comentario = Comentario(
            descricao: descricao,
            data: Date(),
            receita: receitaSwiftData
        )
        
        context.insert(comentario)
        receitaSwiftData.comentarios.append(
            comentario
        )
        
        try context.save()
        
        return ComentarioModel(
            id: comentario.id,
            descricao: comentario.descricao,
            data: comentario.data
        )
    }
    
    func buscarComentarios(
        receita: ReceitaModel
    ) throws -> [ComentarioModel] {
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: #Predicate {
                $0.id == receita.id
            }
        )
        
        guard let receitaSwiftData = try context.fetch(
            descriptor
        ).first else {
            
            return []
        }
        
        return receitaSwiftData.comentarios
            .sorted {
                $0.data > $1.data
            }
            .map {
                ComentarioModel(
                    id: $0.id,
                    descricao: $0.descricao,
                    data: $0.data
                )
            }
    }
    
   
    func apagarReceitasComCategoriaAntiga() throws {
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: #Predicate {
                $0.categoria == "Sobremesas"
            }
        )
        
        let receitas = try context.fetch(
            descriptor
        )
        
        for receita in receitas {
            context.delete(receita)
        }
        
        try context.save()
    }
  
    private func converterReceita(
        _ receita: Receita
    ) -> ReceitaModel {
        
        let categoria: Categoria
        
        switch receita.categoria {
            
        case "Sobremesas":
            categoria = .doces
            
        default:
            
            guard let categoriaConvertida = Categoria(
                rawValue: receita.categoria
            ) else {
                
                fatalError(
                    "Categoria inválida: \(receita.categoria)"
                )
            }
            
            categoria = categoriaConvertida
        }
        
        let ingredientes = receita.ingredientes.compactMap {
            ingrediente -> IngredienteModel? in
            
            guard let unidade = UnidadeMedida(
                rawValue: ingrediente.unidade
            ) else {
                
                return nil
            }
            
            return IngredienteModel(
                id: ingrediente.id,
                nome: ingrediente.nome,
                quantidade: ingrediente.quantidade,
                unidade: unidade
            )
        }
        
        let comentarios = receita.comentarios.map {
            comentario in
            
            ComentarioModel(
                id: comentario.id,
                descricao: comentario.descricao,
                data: comentario.data
            )
        }
        
        return ReceitaModel(
            id: receita.id,
            nome: receita.nome,
            categoria: categoria,
            favorito: receita.favorito,
            dataCriacao: receita.dataCriacao,
            foto: receita.foto,
            porcoes: receita.porcoes,
            duracao: receita.duracao,
            utensilios: receita.utensilios,
            modoPreparo: receita.modoPreparo,
            ingredientes: ingredientes,
            comentarios: comentarios
        )
    }
}
