//
//  Categoria.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation

enum Categoria: String, CaseIterable, Identifiable {
    
    case massas = "Massas"
    case carnes = "Carnes"
    case aves = "Aves"
    case peixesFrutosDoMar = "Peixes e frutos do mar"
    case saladasVegetais = "Saladas e vegetais"
    case sopasCaldos = "Sopas e caldos"
    case arrozGraos = "Arroz e grãos"
    case paesSalgados = "Pães e salgados"
    case sobremesas = "Sobremesas"
    case bebidas = "Bebidas"
    case outro = "Outro"
    
    var id: String {
        rawValue
    }
}
