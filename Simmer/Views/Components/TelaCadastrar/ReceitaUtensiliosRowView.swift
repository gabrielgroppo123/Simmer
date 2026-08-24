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
    
    @State private var mostrandoConfirmacao = false
    
    var body: some View {
        HStack(spacing: 8) {
            
            TextField("Adicionar utensílio",text: $utensilio)
            .font(.system(size: 17))
            
            Button {
                mostrandoConfirmacao = true
            } label: {
                
                Image(systemName: "trash")
                .font(.system(size: 16))
                .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Excluir utensílio")
        }
        .padding(.vertical, 2)
        .alert("Excluir utensílio?",isPresented: $mostrandoConfirmacao) {
            
            Button("Cancelar",role: .cancel) {
                mostrandoConfirmacao = false
            }
            
            Button("Excluir",role: .destructive) {
                remover()
            }
            
        } message: {
            
            Text("Deseja realmente excluir este utensílio?")
        }
    Divider()
    }
}

#Preview {
    ReceitaUtensilioRowView(utensilio: .constant("Batedeira")) {}
}
