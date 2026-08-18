//
//  ReceitaPorcoesView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaPorcoesView: View {
    
    @Binding var porcoes: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "person.2")
                .font(.system(size: 19))
                .frame(width: 28)
            
            Text("Porções")
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
            
            Spacer()
            
            HStack(spacing: 0) {
                
                Button {
                    diminuirPorcoes()
                } label: {
                    Image(systemName: "minus")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .frame(
                            width: 38,
                            height: 38
                        )
                }
                
                Text(
                    porcoes.isEmpty
                        ? "0"
                        : porcoes
                )
                .font(.system(size: 17))
                .frame(width: 34)
                
                Button {
                    aumentarPorcoes()
                } label: {
                    Image(systemName: "plus")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .frame(
                            width: 38,
                            height: 38
                        )
                }
            }
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(Capsule())
        }
    }
    
    private func aumentarPorcoes() {
        
        let atual = Int16(porcoes) ?? 0
        
        porcoes = String(atual + 1)
    }
    
    private func diminuirPorcoes() {
        
        let atual = Int16(porcoes) ?? 0
        
        guard atual > 0 else {
            return
        }
        
        let novoValor = atual - 1
        
        porcoes = novoValor == 0
            ? ""
            : String(novoValor)
    }
}
