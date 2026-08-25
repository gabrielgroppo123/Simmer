//
//  Ingrediente.swift
//  Simmer
//
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 25/08/26.
//
//
//  IngredienteSwiftData.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 25/08/26.
//
import Foundation
import SwiftData

@Model
final class Ingrediente {
    
    @Attribute(.unique)
    var id: UUID
    var nome: String
    var quantidade: Double
    var unidade: String
    
    init(
            id: UUID = UUID(),
            nome: String,
            quantidade: Double,
            unidade: String
        ) {
            self.id = id
            self.nome = nome
            self.quantidade = quantidade
            self.unidade = unidade
        }
    
}
