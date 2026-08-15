//
//  UnidadeMedida.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation

enum UnidadeMedida: String, CaseIterable, Identifiable {
    
    case gramas = "Gramas"
    case kilogramas = "Kilogramas"
    case miligramas = "Miligramas"
    case litros = "Litros"
    case mililitros = "Mililitros"
    case colherCha = "Colher de chá"
    case colherSopa = "Colher de sopa"
    case colherSobremesa = "Colher de sobremesa"
    case colherCafe = "Colher de café"
    case xicara = "Xícara"
    case unidades = "Unidades"
    
    var id: String {
        rawValue
    }
}
