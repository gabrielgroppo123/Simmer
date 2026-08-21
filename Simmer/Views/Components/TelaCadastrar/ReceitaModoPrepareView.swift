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
            spacing: 12
        ) {
            
            HStack(
                alignment: .firstTextBaseline
            ) {
                
                Text("Modo de preparo")
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
            Divider()
            TextField(
                "Ex: Refogue no azeite a cebola, o alho, o tomate e o pimentão...",
                text: $modoPreparo,
                axis: .vertical
            )
            .font(.system(size: 17))
            .lineLimit(2...8)
            
            
        }
    }
}

#Preview("Campo Vazio (Alerta)") {
    ReceitaModoPreparoView(
        modoPreparo: .constant("")
    )
    .padding()
}

#Preview("Campo Preenchido") {
    ReceitaModoPreparoView(
        modoPreparo: .constant(
            "1. Misture todos os ingredientes secos em uma tigela grande.\n2. Adicione os líquidos aos poucos enquanto mexe.\n3. Leve ao forno pré-aquecido a 180°C por 30 minutos."
        )
    )
    .padding()
}
