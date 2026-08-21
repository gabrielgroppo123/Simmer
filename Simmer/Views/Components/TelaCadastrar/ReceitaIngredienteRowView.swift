//
//  ReceitaIngredienteRowView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaIngredienteRowView: View {
    
    @Binding var ingrediente: IngredienteFormulario
    
    let remover: () -> Void
    
    @State private var mostrandoConfirmacao = false
    
    var body: some View {
        
        HStack(
            alignment: .center,
            spacing: 12
        ) {
            
            // MARK: - Nome
            
            TextField(
                "Ex: Leite",
                text: $ingrediente.nome
            )
            .font(.system(size: 16))
            .frame(maxWidth: 120)
            
            // MARK: - Quantidade
            
            TextField(
                "250",
                text: $ingrediente.quantidade
            )
            .font(.system(size: 16))
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .frame(width: 48)
            
            // MARK: - Unidade
            
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
            .pickerStyle(.menu)
            .labelsHidden()
            .frame(
                width: 150,
                alignment: .trailing
            )
            
            // MARK: - Excluir
            
            Button {
                mostrandoConfirmacao = true
            } label: {
                
                Image(
                    systemName: "trash"
                )
                .font(.system(size: 16))
                .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                "Excluir ingrediente"
            )
        }
        .padding(.vertical, 2)
        .alert(
            "Excluir ingrediente?",
            isPresented: $mostrandoConfirmacao
        ) {
            
            Button(
                "Cancelar",
                role: .cancel
            ) {
                mostrandoConfirmacao = false
            }
            
            Button(
                "Excluir",
                role: .destructive
            ) {
                remover()
            }
            
        } message: {
            
            Text(
                "Deseja realmente excluir este ingrediente?"
            )
        }
    }
}

#Preview("Linha Vazia (Placeholder)") {
    
    ReceitaIngredienteRowView(
        ingrediente: .constant(
            IngredienteFormulario()
        ),
        remover: {
            print("Ingrediente removido no Preview")
        }
    )
    .padding()
}

#Preview("Linha Preenchida") {
    
    ReceitaIngredienteRowView(
        ingrediente: .constant(
            IngredienteFormulario(
                nome: "Farinha de Trigo",
                quantidade: "500",
                unidade: .gramas
            )
        ),
        remover: {
            print("Ingrediente removido no Preview")
        }
    )
    .padding()
}
