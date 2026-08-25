//
//  Receita.swift
//  Simmer
//
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 25/08/26.
//

//
//  Receita.swift
//  Simmer
//
//  Created by Gabriel Groppo on 24/08/26.
//


import Foundation
import SwiftData

@Model
final class Receita {
    
    @Attribute(.unique)
    var id: UUID
    
    var nome: String
    var categoria: String
    var favorito: Bool
    var dataCriacao: Date?
    var foto: Data
    var porcoes: Int16
    var duracao: Int64
    var utensilios: String?
    var modoPreparo: String
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \Ingrediente.receita
    )
    var ingredientes: [Ingrediente] = []
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \Comentario.receita
    )
    var comentarios: [Comentario] = []
    
    init(
        id: UUID = UUID(),
        nome: String,
        categoria: String,
        favorito: Bool = false,
        dataCriacao: Date? = Date(),
        foto: Data,
        porcoes: Int16 = 1,
        duracao: Int64,
        utensilios: String? = nil,
        modoPreparo: String
    ) {
        self.id = id
        self.nome = nome
        self.categoria = categoria
        self.favorito = favorito
        self.dataCriacao = dataCriacao
        self.foto = foto
        self.porcoes = porcoes
        self.duracao = duracao
        self.utensilios = utensilios
        self.modoPreparo = modoPreparo
    }
}
