//
//  ReceitaIngredienteRowView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

//import SwiftUI
//
//struct ReceitaIngredienteRowView: View {
//
//    @Binding var ingrediente: IngredienteFormulario
//
//    var body: some View {
//        HStack(
//            alignment: .top,
//            spacing: 12
//        ) {
//
//            TextField(
//                "Ex: Leite",
//                text: $ingrediente.nome
//            )
//            .frame(maxWidth: .infinity)
//
//            TextField(
//                "250",
//                text: $ingrediente.quantidade
//            )
//            .keyboardType(.decimalPad)
//            .multilineTextAlignment(.center)
//            .frame(width: 48)
//
//            Picker(
//                "",
//                selection: $ingrediente.unidade
//            ) {
//
//                ForEach(
//                    UnidadeMedida.allCases
//                ) { unidade in
//
//                    Text(unidade.rawValue)
//                        .tag(unidade)
//                }
//            }
//            .labelsHidden()
//            .frame(width: 132)
//        }
//        .font(.system(size: 16))
//        Divider()
//    }
//}

import SwiftUI

struct ReceitaIngredienteRowView: View {
    
    @Binding var ingrediente: IngredienteFormulario
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            // Campo Nome: Flexível
            TextField("Ex: Leite", text: $ingrediente.nome)
                .font(.system(size: 16))
                .frame(maxWidth: 140)
            
            // Campo Qtd: Largura fixa 48, centralizado
            TextField("250", text: $ingrediente.quantidade)
                .font(.system(size: 16))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 48)
            
            // Picker Unidade: Largura fixa 110, alinhado à direita
            Picker("", selection: $ingrediente.unidade) {
                ForEach(UnidadeMedida.allCases) { unidade in
                    Text(unidade.rawValue).tag(unidade)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .frame(width: 180, alignment: .trailing)
        }
        .padding(.vertical, 2)
    }
}

#Preview("Linha Vazia (Placeholder)") {
    ReceitaIngredienteRowView(
        ingrediente: .constant(
            IngredienteFormulario()
        )
    )
    .padding()
}

#Preview("Linha Preenchida") {
    ReceitaIngredienteRowView(
        ingrediente: .constant(
            IngredienteFormulario(
                nome: "Farinha de Trigo",
                quantidade: "500",
                unidade: .gramas // Ajuste para uma opção válida da sua enum UnidadeMedida
            )
        )
    )
    .padding()
}
