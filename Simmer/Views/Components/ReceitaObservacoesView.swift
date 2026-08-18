//
//  ReceitaObservacoesView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaObservacoesView: View {
    
    @Binding var observacao: String
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            
            HStack {
                
                Text("Observações")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                
                Spacer()
                
                Button {
                    // A ação será conectada
                    // ao Comentario posteriormente.
                } label: {
                    Image(systemName: "plus")
                        .font(
                            .system(
                                size: 20,
                                weight: .medium
                            )
                        )
                        .frame(
                            width: 48,
                            height: 48
                        )
                        .background(
                            Color.gray.opacity(0.08)
                        )
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            
            TextField(
                "Sinta-se livre para adicionar seus pensamentos sobre a receita.",
                text: $observacao,
                axis: .vertical
            )
            .font(.system(size: 15))
            .lineLimit(3...7)
        }
    }
}

#Preview("Campo Vazio (Placeholder)") {
    ReceitaObservacoesView(
        observacao: .constant("")
    )
    .padding()
}

#Preview("Campo Preenchido") {
    ReceitaObservacoesView(
        observacao: .constant(
            "Rendeu exatamente 12 porções! Na próxima vez, vale a pena colocar um pouco menos de açúcar na massa."
        )
    )
    .padding()
}
