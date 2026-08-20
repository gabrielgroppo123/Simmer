//
//  ObservacoesBuscaView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 20/08/26.
//

import SwiftUI

struct ObservacoesBuscaView: View {
    
    @Binding var pesquisa: String
    
    var body: some View {
        
        HStack(spacing: 10) {
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
            
            TextField(
                "Pesquise sua receita",
                text: $pesquisa
            )
            
            if !pesquisa.isEmpty {
                
                Button {
                    pesquisa = ""
                } label: {
                    Image(
                        systemName:
                            "xmark.circle.fill"
                    )
                    .foregroundStyle(.secondary)
                }
            }
            
            Image(systemName: "mic.fill")
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(
            .ultraThinMaterial
        )
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .stroke(
                    Color.gray.opacity(0.25),
                    lineWidth: 1
                )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}
