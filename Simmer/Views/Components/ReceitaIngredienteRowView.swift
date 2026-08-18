//
//  ReceitaIngredienteRowView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaIngredienteRowView: View {
    
    @Binding var ingrediente: IngredienteFormulario
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            
            TextField(
                "Ex: Leite",
                text: $ingrediente.nome
            )
            .frame(maxWidth: .infinity)
            
            TextField(
                "250",
                text: $ingrediente.quantidade
            )
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .frame(width: 48)
            
            Picker(
                "",
                selection: $ingrediente.unidade
            ) {
                
                ForEach(
                    UnidadeMedida.allCases
                ) { unidade in
                    
                    Text(unidade.rawValue)
                        .tag(unidade)
                }
            }
            .labelsHidden()
            .frame(width: 78)
        }
        .font(.system(size: 16))
        
        Divider()
    }
}
