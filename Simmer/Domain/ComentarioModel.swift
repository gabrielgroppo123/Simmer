//
//  ComentarioModel.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import Foundation

struct ComentarioModel: Identifiable {
    
    let id: UUID
    let descricao: String
    let data: Date
}
