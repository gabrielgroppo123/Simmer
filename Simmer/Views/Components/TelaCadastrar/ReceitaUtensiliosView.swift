//
//  ReceitaUtensiliosView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaUtensiliosView: View {
    
    @Binding var utensilios: [String]
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            
            Text("Utensílios")
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )
            
            ForEach(
                utensilios.indices,
                id: \.self
            ) { indice in
                
                ReceitaUtensilioRowView(
                    utensilio: $utensilios[indice]
                ) {
                    removerUtensilio(
                        no: indice
                    )
                }
            }
            
            Button {
                utensilios.append("")
            } label: {
                Label(
                    "Adicionar utensílio",
                    systemImage: "plus.circle"
                )
                .font(.system(size: 15))
            }
        }
    }
    
    private func removerUtensilio(
        no indice: Int
    ) {
        guard utensilios.indices.contains(indice) else {
            return
        }
        
        utensilios.remove(at: indice)
    }
}
