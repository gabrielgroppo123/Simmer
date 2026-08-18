//
//  ReceitaUtensiliosRowView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaUtensilioRowView: View {
    
    @Binding var utensilio: String
    
    let remover: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            
            TextField(
                "Adicionar utensílio",
                text: $utensilio
            )
            .font(.system(size: 17))
            
            Button {
                remover()
            } label: {
                Image(
                    systemName: "minus.circle"
                )
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                "Remover utensílio"
            )
        }
        
        Divider()
    }
}
