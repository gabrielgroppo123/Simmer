//
//  EditarReceitaInformacoesView.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 18/08/26.
//
import SwiftUI

struct EditarReceitaInformacoesView: View {

    @Binding var nome: String
    @Binding var categoria: Categoria
    @Binding var porcoes: String
    @Binding var duracao: String
    @Binding var utensilios: String
    @Binding var modoPreparo: String

    var body: some View {

        TextField(
            "Nome da receita",
            text: $nome
        )
        
        
        TextField(
            "Duração em minutos",
            text: $duracao
        )
        .keyboardType(.numberPad)
        
        
        TextField(
            "Porções",
            text: $porcoes
        )
        .keyboardType(.numberPad)

        
        Picker(
            "Categoria",
            selection: $categoria
        ) {
            ForEach(Categoria.allCases) { categoria in
                Text(categoria.rawValue)
                    .tag(categoria)
            }
        }

       

        

//        TextField(
//            "Utensílios",
//            text: $utensilios
//        )
//
//        TextField(
//            "Modo de preparo",
//            text: $modoPreparo,
//            axis: .vertical
//        )
//        .lineLimit(4...8)
    }
}

