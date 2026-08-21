//
//  ReceitaIngredienteFomrulario.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//
import Foundation

struct IngredienteFormulario: Identifiable {
    
    let id: UUID
    
    var nome: String
    var quantidade: String
    var unidade: UnidadeMedida
    
    init(
        id: UUID = UUID(),
        nome: String = "",
        quantidade: String = "",
        unidade: UnidadeMedida = .unidades
    ) {
        self.id = id
        self.nome = nome
        self.quantidade = quantidade
        self.unidade = unidade
    }
}
