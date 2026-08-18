//
//  ReceitaIngredientesView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaIngredientesView: View {
    
    @Binding var ingredientes: [IngredienteFormulario]
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            HStack(
                alignment: .firstTextBaseline
            ) {
                
                Text("Ingredientes")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                
                Text("*")
                    .foregroundStyle(.red)
                
                Spacer()
                
                if ingredientes.isEmpty {
                    Text("campo obrigatório")
                        .font(.system(size: 12))
                        .foregroundStyle(
                            .red.opacity(0.75)
                        )
                }
            }
            
            HStack(spacing: 12) {
                
                Text("Nome do ingrediente")
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                
                Text("Qtd")
                    .frame(
                        width: 48,
                        alignment: .leading
                    )
                
                Text("Unidade")
                    .frame(
                        width: 78,
                        alignment: .leading
                    )
            }
            .font(.system(size: 14))
            
            ForEach(
                $ingredientes
            ) { $ingrediente in
                
                ReceitaIngredienteRowView(
                    ingrediente: $ingrediente
                )
            }
            .onDelete { offsets in
                ingredientes.remove(
                    atOffsets: offsets
                )
            }
            
            Button {
                adicionarIngrediente()
            } label: {
                Label(
                    "Adicionar ingrediente",
                    systemImage: "plus.circle"
                )
                .font(.system(size: 15))
            }
        }
    }
    
    private func adicionarIngrediente() {
        ingredientes.append(
            IngredienteFormulario()
        )
    }
}
