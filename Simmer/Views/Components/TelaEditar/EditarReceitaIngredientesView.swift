//
//  EditarReceitaIngredientesView.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 18/08/26.
//
import SwiftUI

struct EditarReceitaIngredientesView: View {

    @Binding var ingredientes: [IngredienteFormulario]

    var adicionarIngrediente: () -> Void

    var body: some View {

        Section("Ingredientes") {

            ForEach($ingredientes) { $ingrediente in

                EditarReceitaIngredienteRowView(
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
                    systemImage: "plus"
                )
            }
        }
    }
}
