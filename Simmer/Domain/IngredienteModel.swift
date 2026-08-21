//
//  IngredienteModel.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation

struct IngredienteModel: Identifiable {
    
    let id: UUID
    let nome: String
    let quantidade: Double
    let unidade: UnidadeMedida
}
