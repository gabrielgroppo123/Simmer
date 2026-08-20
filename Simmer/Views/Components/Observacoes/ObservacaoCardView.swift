//
//  ObservacaoCardView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 20/08/26.
//

import SwiftUI

struct ObservacaoCardView: View {
    
    let observacao: ComentarioModel
    
    private var dataFormatada: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter.string(
            from: observacao.data
        )
    }
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 24
        ) {
            
            Text(dataFormatada)
                .font(
                    .system(
                        size: 21,
                        weight: .bold
                    )
                )
            
            Text(observacao.descricao)
                .font(
                    .system(
                        size: 20,
                        weight: .regular
                    )
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(24)
        .background(
            Color.cardObservacoes
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22
            )
        )
        .overlay {
            
            RoundedRectangle(
                cornerRadius: 22
            )
            .stroke(
                Color(
                    red: 1.0,
                    green: 0.90,
                    blue: 0.82
                ),
                lineWidth: 1
            )
        }
    }
}   
