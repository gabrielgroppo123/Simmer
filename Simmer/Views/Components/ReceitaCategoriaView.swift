//
//  ReceitaCategoriaView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaCategoriaView: View {
    
    @Binding var categoria: Categoria
    
    var body: some View {
        HStack {
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 19))
                .frame(width: 28)
            
            Text("Categoria")
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
            
            Spacer()
            
            Menu {
                
                ForEach(Categoria.allCases) { categoria in
                    
                    Button {
                        self.categoria = categoria
                    } label: {
                        Text(categoria.rawValue)
                    }
                }
                
            } label: {
                
                HStack(spacing: 7) {
                    
                    Text(
                        categoria == .outro
                            ? "Escolher"
                            : categoria.rawValue
                    )
                    .font(.system(size: 15))
                    .foregroundStyle(
                        categoria == .outro
                            ? .secondary
                            : .primary
                    )
                    
                    Image(
                        systemName:
                            "chevron.up.chevron.down"
                    )
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(
                    Color.gray.opacity(0.10)
                )
                .clipShape(Capsule())
            }
        }
    }
}

#Preview("Estado Inicial (Outro)") {
    ReceitaCategoriaView(
        categoria: .constant(.outro)
    )
    .padding()
}

#Preview("Categoria Selecionada") {
    // Altere para qualquer outro caso válido da sua enum Categoria (ex: .almoco)
    ReceitaCategoriaView(
        categoria: .constant(.massas)
    )
    .padding()
}
