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
                VStack (alignment: .leading){
                    Text("Observações")
                        .font(.custom("Alexandria-SemiBold", size: 22))
                        .foregroundColor(.primary)
                        .padding(.bottom, 12)
                    
                    Text("Sugestão: descreva não só sabores, mas sentimentos, expectativas, dificuldades no seu processo com a receita.")
                        .font(.custom("Alexandria-Light", size: 17))
                        .foregroundColor(.primary)
                }
                Spacer()
                
            }
            Divider()
            TextField(
                "Ex: Vi essa receita na internet e parece boa.",
                text: $observacao,
                axis: .vertical
            )
            .font(.system(size: 15))
            .foregroundColor(.secondary)
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
