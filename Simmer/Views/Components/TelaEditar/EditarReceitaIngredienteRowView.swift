//
//  EditarReceitaIngredienteRowView.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 18/08/26.
//
import SwiftUI

struct EditarReceitaIngredienteRowView: View {

    @Binding var ingrediente: IngredienteFormulario

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            TextField(
                "Nome do ingrediente",
                text: $ingrediente.nome
            )

            HStack {

                TextField(
                    "Quantidade",
                    text: $ingrediente.quantidade
                )
                .keyboardType(.decimalPad)

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
            }
        }
        .padding(.vertical, 4)
    }
}
