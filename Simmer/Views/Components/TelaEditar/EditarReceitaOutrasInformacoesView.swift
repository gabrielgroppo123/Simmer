//
//  EditarReceitaOutrasInformacoesView.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 18/08/26.
//
import SwiftUI

struct EditarReceitaOutrasInformacoesView: View {
    
    @Binding var utensilios: String
    @Binding var modoPreparo: String
    
    var body: some View {
        
        TextField(
            "Utensílios",
            text: $utensilios
        )

        TextField(
            "Modo de preparo",
            text: $modoPreparo,
            axis: .vertical
        )
        .lineLimit(4...8)
        
    }
    
}
