//
//  ReceitaCampoNomeView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaCampoNomeView: View {
    
    @Binding var nome: String
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            
            HStack(
                alignment: .firstTextBaseline
            ) {
                
                Text("Nome da Receita")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )
                
                Text("*")
                    .foregroundStyle(.red)
                
                Spacer()
                
                if nome.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty {
                    
                    Text("campo obrigatório")
                        .font(.system(size: 12))
                        .foregroundStyle(
                            .red.opacity(0.75)
                        )
                }
            }
            
            TextField(
                "Ex: Pudim",
                text: $nome
            )
            .font(.system(size: 18))
            .textInputAutocapitalization(.sentences)
            
            Divider()
        }
    }
}
