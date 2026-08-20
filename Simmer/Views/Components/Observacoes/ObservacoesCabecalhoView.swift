//
//  ObservacoesCabecalhoView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 20/08/26.
//

import SwiftUI

struct ObservacoesCabecalhoView: View {
    
    let voltar: () -> Void
    let adicionar: () -> Void
    
    var body: some View {
        
        HStack {
            
            Button {
                voltar()
            } label: {
                Image(systemName: "chevron.left")
                    .font(
                        .system(
                            size: 18,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.black)
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .background(
                        Color(.systemBackground)
                    )
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.gray.opacity(0.18),
                                lineWidth: 1
                            )
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Voltar")
            
            Spacer()
            
            Text("Observações")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
            
            Spacer()
            
            Button {
                adicionar()
            } label: {
                Image(systemName: "plus")
                    .font(
                        .system(
                            size: 18,
                            weight: .medium
                        )
                    )
                    .tint(.primary)
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .background(
                        Color.orange
                    )
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                "Adicionar observação"
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }
}
