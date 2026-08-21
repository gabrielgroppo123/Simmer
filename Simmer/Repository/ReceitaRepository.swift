//
//  ReceitaRepository.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation

protocol ReceitaRepository {
    
    func criarReceita(_ dados: NovaReceita) throws -> ReceitaModel
    
    func buscarReceitas() throws -> [ReceitaModel]
    
    func buscarReceitas(texto: String) throws -> [ReceitaModel]
    
    func buscarReceita(id: UUID) throws -> ReceitaModel?
    
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
    ) throws
    
    func atualizarFavorito(
        _ receita: ReceitaModel,
        favorito: Bool
    ) throws
    
    func criarComentario(
        descricao: String,
        receita: ReceitaModel
    ) throws -> ComentarioModel

    func buscarComentarios(
        receita: ReceitaModel
    ) throws -> [ComentarioModel]
    
    func deletarReceita(_ receita: ReceitaModel) throws
    
    func apagarReceitasComCategoriaAntiga() throws
}
