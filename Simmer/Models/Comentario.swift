//
//  Comentario.swift
//  Simmer
//
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 25/08/26.
//
import SwiftData
import Foundation

// 1. A macro @Model indica ao SwiftData que esta classe é um modelo de banco de dados persistence.
@Model
final class Comentario {
    
    // 2. @Attribute(.unique) garante que o ID do comentário seja único na base de dados.
    @Attribute(.unique) var id: UUID
    var descricao: String
    var data: Date
    
    // 4. Relacionamento inverso: Indica a qual Receita este comentário pertence.
    // O SwiftData gerencia os ponteiros e buscas automaticamente.
    var receita: Receita?
    
    // 5. Construtor (Initializer): O SwiftData exige um init explícito para instanciar a classe.
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

