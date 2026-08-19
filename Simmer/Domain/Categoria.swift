//
//  Categoria.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation

enum Categoria: String, CaseIterable, Identifiable, Hashable {
    
    case aves = "Aves"
    case bebidas = "Bebidas"
    case carnes = "Carnes"
    case sobremesas = "Doces"
    case arrozGraos = "Grãos e leguminosas"
    case saladasVegetais = "Legumes e vegetais"
    case massas = "Massas"
    case paesSalgados = "Pães e salgados"
    case peixesFrutosDoMar = "Peixes e frutos do mar"
    case sopasCaldos = "Sopas e caldos"
    case outro = "Outros"
    
    var id: String {
        rawValue
    }
}
