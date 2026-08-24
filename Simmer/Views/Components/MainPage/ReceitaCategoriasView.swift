////
////  ReceitaCategoriasView.swift
////  Simmer
////
////  Created by Gabriel Groppo on 18/08/26.
////

import SwiftUI  

struct ReceitaCategoriasView: View {
    
    let categorias: [Categoria]
    let selecionarCategoria: (Categoria) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Categorias")
                .font(.custom("Alexandria-SemiBold", size: 22))
                .foregroundColor(.primary)

            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categorias) { categoria in
                        Button {
                            selecionarCategoria(categoria)
                        } label: {
                            ReceitaCategoriaCardView(categoria: categoria)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
