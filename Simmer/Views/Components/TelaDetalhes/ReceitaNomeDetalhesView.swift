//
//  ReceitaNomeDetalhesView.swift
//  Simmer
//
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 20/08/26.
//
import SwiftUI

struct ReceitaCampoNomeExibicaoView: View {
    
    let nome: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Nome da Receita")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.primary)
            
            Text(nome.isEmpty ? "Sem nome" : nome)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.primary)
            
            Divider()
        }
    }
}

#Preview {
    ReceitaCampoNomeExibicaoView(nome: "bolooo")
}
