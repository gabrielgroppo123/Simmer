//
//  SwiftDataReceitaRepository.swift
//  Simmer
//
//  Created by Gabriel Groppo on 25/08/26.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataReceitaRepository: ReceitaRepository {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func criarReceita( _ dados: NovaReceita) throws -> ReceitaModel {
        
        let receita = Receita(
            nome: dados.nome,
            categoria: dados.categoria.rawValue,
            favorito: false,
            dataCriacao: Date(),
            foto: dados.foto,
            porcoes: dados.porcoes ?? 1,
            duracao: dados.duracao,
            utensilios: dados.utensilios,
            modoPreparo: dados.modoPreparo)
        
        context.insert(receita)
        
        for dadosIngrediente in dados.ingredientes {
            
            let ingrediente = Ingrediente(
                nome: dadosIngrediente.nome,
                quantidade: dadosIngrediente.quantidade,
                unidade: dadosIngrediente.unidade.rawValue,
                receita: receita)
            
            context.insert(ingrediente)
        }
        
        try context.save()
        
        return converterReceita(receita)
    }
    
    func buscarReceitas() throws -> [ReceitaModel] {
        
        let descriptor = FetchDescriptor<Receita>(
            sortBy: [SortDescriptor<Receita>(\.dataCriacao,order: .reverse)])
        
        let receitas = try context.fetch(descriptor)
        
        return receitas.map {
            converterReceita($0)
        }
    }
    
    func buscarReceitas(texto: String) throws -> [ReceitaModel] {
        
        let descriptor = FetchDescriptor<Receita>(
            sortBy: [SortDescriptor<Receita>(\.dataCriacao,order: .reverse)])
        
        let receitas = try context.fetch(descriptor)
        
        let textoNormalizado = texto
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textoNormalizado.isEmpty {
            return receitas.map {
                converterReceita($0)
            }
        }
        
        return receitas
            .filter {
                $0.nome.localizedCaseInsensitiveContains(textoNormalizado)
            }
            .map {
                converterReceita($0)
            }
    }
    
    func buscarReceita(id: UUID) throws -> ReceitaModel? {
        
        let idReceita = id
        
        let predicate = #Predicate<Receita> { receita in
            receita.id == idReceita
        }
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: predicate
        )
        
        guard let receita = try context.fetch(descriptor).first else {
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
        
        let idReceita = receita.id
        
        let predicate = #Predicate<Receita> { receitaSwiftData in
            receitaSwiftData.id == idReceita
        }
        
        let descriptor = FetchDescriptor<Receita>(
            predicate: predicate
        )
        
        guard let receitaSwiftData = try context.fetch(descriptor).first else {
            return
        }
        
        receitaSwiftData.nome = nome
        receitaSwiftData.categoria = categoria.rawValue
        receitaSwiftData.foto = foto
        receitaSwiftData.porcoes = porcoes
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
                receita: receitaSwiftData)
            
            context.insert(ingrediente)
        }
        
        try context.save()
    }
    
    func atualizarFavorito(_ receita: ReceitaModel,favorito: Bool) throws {
        
        let idReceita = receita.id
        
        let predicate = #Predicate<Receita> { receitaSwiftData in
            receitaSwiftData.id == idReceita
        }
        
        let descriptor = FetchDescriptor<Receita>(predicate: predicate)
        
        guard let receitaSwiftData = try context.fetch(descriptor).first else {
            return
        }
        
        receitaSwiftData.favorito = favorito
        
        try context.save()
    }
    
    func deletarReceita(_ receita: ReceitaModel) throws {
        
        let idReceita = receita.id
        
        let predicate = #Predicate<Receita> { receitaSwiftData in
            receitaSwiftData.id == idReceita
        }
        
        let descriptor = FetchDescriptor<Receita>(predicate: predicate)
        
        guard let receitaSwiftData = try context.fetch(descriptor).first else {
            return
        }
        
        context.delete(receitaSwiftData)
        
        try context.save()
    }
    
    func apagarReceitasComCategoriaAntiga() throws {
        
        let predicate = #Predicate<Receita> { receita in
            receita.categoria == "Sobremesas"
        }
        
        let descriptor = FetchDescriptor<Receita>(predicate: predicate)
        
        let receitas = try context.fetch(descriptor)
        
        for receita in receitas {
            context.delete(receita)
        }
        
        try context.save()
        
        print("\(receitas.count) receita(s) antiga(s) removida(s).")
    }
    
    
    func criarComentario(descricao: String,receita: ReceitaModel) throws -> ComentarioModel {
        
        let idReceita = receita.id
        
        let predicate = #Predicate<Receita> { receitaSwiftData in
            receitaSwiftData.id == idReceita
        }
        
        let descriptor = FetchDescriptor<Receita>(predicate: predicate)
        
        guard let receitaSwiftData = try context.fetch(descriptor).first else {
            
            throw NSError(domain: "Simmer",code: 404,userInfo: [NSLocalizedDescriptionKey:"A receita não foi encontrada no SwiftData."])
        }
        
        let comentario = Comentario(
            descricao: descricao,
            data: Date(),
            receita: receitaSwiftData)
        
        context.insert(comentario)
        
        try context.save()
        
        return ComentarioModel(
            id: comentario.id,
            descricao: comentario.descricao,
            data: comentario.data)
    }
    
    func buscarComentarios(receita: ReceitaModel) throws -> [ComentarioModel] {
        
        let comentarios = try context.fetch(FetchDescriptor<Comentario>(sortBy: [SortDescriptor<Comentario>(\.data,order: .reverse)]))
        
        return comentarios
            .filter {
                $0.receita?.id == receita.id
            }
            .map {
                ComentarioModel(
                    id: $0.id,
                    descricao: $0.descricao,
                    data: $0.data)
            }
    }
    
    private func converterReceita(_ receita: Receita) -> ReceitaModel {
        
        let ingredientes = receita.ingredientes.map {
            
            IngredienteModel(
                id: $0.id,
                nome: $0.nome,
                quantidade: $0.quantidade,
                unidade: UnidadeMedida(rawValue: $0.unidade) ?? .gramas)
        }
        
        let comentarios = receita.comentarios.map {
            
            ComentarioModel(
                id: $0.id,
                descricao: $0.descricao,
                data: $0.data)
        }
        
        return ReceitaModel(
            id: receita.id,
            nome: receita.nome,
            categoria: Categoria(
                rawValue: receita.categoria
            ) ?? .outro,
            favorito: receita.favorito,
            dataCriacao: receita.dataCriacao,
            foto: receita.foto,
            porcoes: receita.porcoes,
            duracao: receita.duracao,
            utensilios: receita.utensilios,
            modoPreparo: receita.modoPreparo,
            ingredientes: ingredientes,
            comentarios: comentarios)
    }
}
