//
//  Categoria.swift
//  Simmer
//
//  Created by Mariana Fracaroli on 15/08/26.
//

import Foundation

enum Categoria: String, CaseIterable, Identifiable, Hashable {
    
    case aves = "Aves"
    case bebidas = "Bebidas"
    case carnes = "Carnes vermelhas"
    case doces = "Doces"
    case arrozGraos = "Grãos & leguminosas"
    case saladasVegetais = "Legumes & vegetais"
    case massas = "Massas"
    case paesSalgados = "Pães & salgados"
    case peixesFrutosDoMar = "Peixes & frutos do mar"
    case sopasCaldos = "Sopas & caldos"
    case outro = "Outros"
    
    var id: String {
        rawValue
    }
}
