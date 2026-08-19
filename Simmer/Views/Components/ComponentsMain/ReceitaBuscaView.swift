//
//  ReceitaBuscaView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaBuscaView: View {
    
    @Binding var textoBusca: String
    
    let estaOuvindo: Bool
    let iniciarBuscaPorVoz: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            
            Image(
                systemName: "magnifyingglass"
            )
            .font(.system(size: 17))
            .foregroundStyle(.primary)
            
            TextField(
                "Pesquise sua receita",
                text: $textoBusca
            )
            .font(.system(size: 16))
            
            Button {
                iniciarBuscaPorVoz()
            } label: {
                Image(
                    systemName: estaOuvindo
                        ? "mic.fill"
                        : "mic"
                )
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
            }
            .accessibilityLabel(
                estaOuvindo
                    ? "Parar pesquisa por voz"
                    : "Pesquisar por voz"
            )
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(
            Color.gray.opacity(0.08)
        )
        .overlay {
            Capsule()
                .stroke(
                    Color.gray.opacity(0.12),
                    lineWidth: 1
                )
        }
        .clipShape(Capsule())
    }
}
