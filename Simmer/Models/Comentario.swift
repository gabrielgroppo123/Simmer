//
//  Comentario.swift
//  Simmer
//
//  Created by Rebeca Calmon on 25/08/26.
//

import Foundation
import SwiftData

@Model
final class Comentario {
    
    @Attribute(.unique)
    var id: UUID
    
    var descricao: String
    var data: Date
    
    var receita: Receita?
    
    init(
        id: UUID = UUID(),
        descricao: String,
        data: Date = Date(),
        receita: Receita? = nil
    ) {
        self.id = id
        self.descricao = descricao
        self.data = data
        self.receita = receita
    }
}
