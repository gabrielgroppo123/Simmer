//
//  ReceitaIngredientesView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

//import SwiftUI
//
//struct ReceitaIngredientesView: View {
//
//    @Binding var ingredientes: [IngredienteFormulario]
//
//    var body: some View {
//        VStack(
//            alignment: .leading,
//            spacing: 16
//        ) {
//
//            HStack(
//                alignment: .firstTextBaseline
//            ) {
//
//                Text("Ingredientes")
//                    .font(
//                        .system(
//                            size: 22,
//                            weight: .semibold
//                        )
//                    )
//
//                Text("*")
//                    .foregroundStyle(.red)
//
//                Spacer()
//
//                if ingredientes.isEmpty {
//                    Text("campo obrigatório")
//                        .font(.system(size: 12))
//                        .foregroundStyle(
//                            .red.opacity(0.75)
//                        )
//                }
//            }
//
//            HStack(spacing: 12) {
//
//                Text("Nome do ingrediente")
//                    .frame(
//                        maxWidth: .infinity,
//                        alignment: .leading
//                    )
//
//                Text("Qtd")
//                    .frame(
//                        width: 88,
//                        alignment: .leading
//                    )
//
//                Text("Unidade")
//                    .frame(
//                        width: 88,
//                        alignment: .leading
//                    )
//            }
//            .font(.system(size: 14))
//
//            ForEach(
//                $ingredientes
//            ) { $ingrediente in
//
//                ReceitaIngredienteRowView(
//                    ingrediente: $ingrediente
//                )
//            }
//            .onDelete { offsets in
//                ingredientes.remove(
//                    atOffsets: offsets
//                )
//            }
//
//            Button {
//                adicionarIngrediente()
//            } label: {
//                Label(
//                    "Adicionar ingrediente",
//                    systemImage: "plus.circle"
//                )
//                .font(.system(size: 15))
//            }
//        }
//    }
//
//    private func adicionarIngrediente() {
//        ingredientes.append(
//            IngredienteFormulario()
//        )
//    }
//}

import SwiftUI

struct ReceitaIngredientesView: View {
    
    @Binding var ingredientes: [IngredienteFormulario]
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            // MARK: - Cabeçalho
            HStack(alignment: .firstTextBaseline) {
                Text("Ingredientes")
                    .font(.system(size: 22, weight: .bold))
                
                Text("*")
                    .foregroundStyle(.red)
                
                Spacer()
                
                if ingredientes.isEmpty {
                    Text("campo obrigatório")
                        .font(.system(size: 13))
                        .foregroundStyle(.red.opacity(0.8))
                }
            }
            
            // MARK: - Títulos das Colunas (Alinhados com a RowView)
            HStack(spacing: 12) {
                
                // Coluna 1: Nome (Ocupa o espaço restante)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Nome")
                        .font(.system(size: 15, weight: .semibold))
                    Divider()
                }
                .frame(maxWidth: 140, alignment: .leading)
                
                // Coluna 2: Qtd (Largura fixa 48, centralizado)
                VStack(alignment: .center, spacing: 6) {
                    Text("Qtd")
                        .font(.system(size: 15, weight: .semibold))
                    Divider()
                }
                .frame(width: 48)
                
                // Coluna 3: Unidade (Largura fixa 110, alinhado à direita para coincidir com o Picker)
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Unidade")
                        .font(.system(size: 15, weight: .semibold))
                    Divider()
                }
                .frame(width: 180, alignment: .trailing)
            }
            
            // MARK: - Lista de Ingredientes
            ForEach($ingredientes) { $ingrediente in
                ReceitaIngredienteRowView(ingrediente: $ingrediente)
            }
            .onDelete { offsets in
                ingredientes.remove(atOffsets: offsets)
            }
            
            // MARK: - Botão Adicionar
            Button {
                adicionarIngrediente()
            } label: {
                Label("Adicionar ingrediente", systemImage: "plus.circle")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.blue)
            }
            .padding(.top, 4)
        }
    }
    
    private func adicionarIngrediente() {
        ingredientes.append(IngredienteFormulario())
    }
}

#Preview("Lista com Itens Interativa") {
    @Previewable @State var ingredientes: [IngredienteFormulario] = [
        IngredienteFormulario(nome: "Farinha de Trigo", quantidade: "500", unidade: .gramas),
        IngredienteFormulario(nome: "Ovos", quantidade: "3", unidade: .unidades)
    ]
    
    return ReceitaIngredientesView(ingredientes: $ingredientes)
        .padding()
}

