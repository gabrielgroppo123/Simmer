//
//  CardObservacaoDetalhes.swift
//  Simmer
//
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 20/08/26.
//
import SwiftUI

struct CardObservacaoDetalhes: View {
    let comentario: ComentarioModel
    
    var body: some View {
        CardDetalhesView(paddingVertical: 20, paddingHorizontal: 20) {
            VStack(alignment: .leading, spacing: 12) {
                
                Text(comentario.data, style: .date)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(comentario.descricao)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(width: 300)
    }
}
