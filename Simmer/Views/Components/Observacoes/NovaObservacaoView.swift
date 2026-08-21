//
//  NovaObservacaoView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 20/08/26.
//

import SwiftUI

struct NovaObservacaoView: View {
    
    @Binding var texto: String
    
    let adicionar: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading,spacing: 20) {
                
                Text("Nova observação")
                    .font(.system(size: 24,weight: .bold))
                
                TextEditor(text: $texto)
                    .font(.system(size: 18))
                    .foregroundStyle(
                        colorScheme == .dark
                        ? .white
                        : .black
                    )
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(
                        colorScheme == .dark
                        ? Color.black
                        : Color(red: 1.0,green: 0.98,blue: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        
                        RoundedRectangle(
                            cornerRadius: 18
                        )
                        .stroke(
                            colorScheme == .dark
                            ? Color.white.opacity(0.35)
                            : Color(red: 1.0,green: 0.90,blue: 0.82),lineWidth: 1)
                    }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Observação")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button {
                        adicionar()
                    } label: {
                        Text("Adicionar")
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color(red: 1.0,green: 0.67,blue: 0.20))
                }
            }
        }
    }
}
