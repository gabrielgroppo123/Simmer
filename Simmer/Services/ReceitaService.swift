//
//  ReceitaService.swift
//  Simmer
//
//  Created by Gabriel Groppo on 14/08/26.
//
import Foundation

struct NovaReceita {
    let nome: String
    let categoria: Categoria
    let foto: Data
    let porcoes: Int16
    let duracao: Int64
    let utensilios: String?
    let modoPreparo: String
    let ingredientes: [NovoIngrediente]
}

struct NovoIngrediente {
    let nome: String
    let quantidade: Double
    let unidade: UnidadeMedida
    
}

final class ReceitaService {
    
    private let repository: ReceitaRepository
    
    init(repository: ReceitaRepository) {
        self.repository = repository
    }
    
    func criarReceita(_ dados: NovaReceita) throws -> ReceitaModel {
        try repository.criarReceita(dados)
    }
    
    func buscarReceitas() throws -> [ReceitaModel] {
        try repository.buscarReceitas()
    }
    
    func buscarReceitas(texto: String) throws -> [ReceitaModel] {
        try repository.buscarReceitas(texto: texto)
    }
    
    func buscarReceita(id: UUID) throws -> ReceitaModel? {
        try repository.buscarReceita(id: id)
    }
    
    func atualizarReceita(
        _ receita: ReceitaModel,
        nome: String,
        categoria: Categoria,
        porcoes: Int16,
        duracao: Int64,
        utensilios: String?,
        modoPreparo: String
    ) throws {
        
        try repository.atualizarReceita(
            receita,
            nome: nome,
            categoria: categoria,
            porcoes: porcoes,
            duracao: duracao,
            utensilios: utensilios,
            modoPreparo: modoPreparo
        )
    }
    
    func atualizarFavorito(
        _ receita: ReceitaModel,
        favorito: Bool
    ) throws {
        
        try repository.atualizarFavorito(
            receita,
            favorito: favorito
        )
    }
    
    func deletarReceita(_ receita: ReceitaModel) throws {
        try repository.deletarReceita(receita)
    }
}
