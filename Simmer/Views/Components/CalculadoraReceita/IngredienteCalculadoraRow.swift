//
//  IngredienteCalculadoraRow.swift
//  Simmer
//
//  Created by Gabriel Groppo on 20/08/26.
//

import SwiftUI

struct IngredienteCalculadoRowView: View {
    
    let ingrediente: IngredienteModel
    let fator: Double
    
    private var quantidadeCalculada: Double {
        ingrediente.quantidade * fator
    }
    
    var body: some View {
        HStack {
            
            Text(
                formatarQuantidade(
                    quantidadeCalculada
                )
            )
            .font(
                .system(
                    size: 16,
                    weight: .semibold
                )
            )
            
            Text(
                ingrediente.unidade.rawValue
            )
            .foregroundStyle(.secondary)
            
            Text(ingrediente.nome)
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
    
    private func formatarQuantidade(
        _ quantidade: Double
    ) -> String {
        
        if quantidade.rounded() == quantidade {
            return String(Int(quantidade))
        }
        
        return String(
            format: "%.2f",
            quantidade
        )
        .replacingOccurrences(
            of: ".",
            with: ","
        )
    }
}
