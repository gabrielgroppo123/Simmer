//
//  ReceitaModoPrepareView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaModoPreparoView: View {
    
    @Binding var modoPreparo: String
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            
            HStack(
                alignment: .firstTextBaseline
            ) {
                
                Text("Modo de Fazer")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                
                Text("*")
                    .foregroundStyle(.red)
                
                Spacer()
                
                if modoPreparo.trimmingCharacters(
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
                "Ex: Refogue no azeite a cebola, o alho, o tomate e o pimentão...",
                text: $modoPreparo,
                axis: .vertical
            )
            .font(.system(size: 17))
            .lineLimit(5...8)
            
            Divider()
        }
    }
}
