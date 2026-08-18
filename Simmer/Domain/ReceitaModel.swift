//
//  ReceitaModel.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation

struct ReceitaModel: Identifiable {
    
    let id: UUID
    let nome: String
    let categoria: Categoria
    let favorito: Bool
    let dataCriacao: Date?
    let foto: Data
    let porcoes: Int16?
    let duracao: Int64
    let utensilios: String?
    let modoPreparo: String
    let ingredientes: [IngredienteModel]
    let comentarios: [ComentarioModel]
}
