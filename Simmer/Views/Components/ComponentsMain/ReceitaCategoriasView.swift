////
////  ReceitaCategoriasView.swift
////  Simmer
////
////  Created by Gabriel Groppo on 18/08/26.
////
//
//import SwiftUI
//
//struct ReceitaCategoriaCardView: View {
//    
//    let categoria: Categoria
//    
//    var body: some View {
//        VStack(
//            alignment: .leading
//        ) {
//            
//            Text(nomeCategoria)
//                .font(
//                    .system(
//                        size: 14,
//                        weight: .medium
//                    )
//                )
//                .foregroundStyle(.white)
//                .multilineTextAlignment(.leading)
//                .lineLimit(2)
//                .fixedSize(
//                    horizontal: false,
//                    vertical: false
//                )
//            
//            
//            HStack {
//                Spacer()
//                
//                Image(systemName: iconeCategoria)
//                    .font(
//                        .system(size: 28)
//                    )
//                    .foregroundStyle(
//                        .white.opacity(0.75)
//                    )
//            }
//        }
//        .padding(10)
//        .frame(
//            width: 128,
//            height: 90
//        )
//        .background(
//            corCategoria
//        )
//        .clipShape(
//            RoundedRectangle(
//                cornerRadius: 15
//            )
//        )
//    }
//    
//    private var nomeCategoria: String {
//        switch categoria {
//        case .aves:
//            return "Aves"
//            
//        case .bebidas:
//            return "Bebidas"
//            
//        case .carnes:
//            return "Carnes\nvermelhas"
//            
//        case .sobremesas:
//            return "Doces"
//            
//        case .arrozGraos:
//            return "Grãos &\nLeguminosas"
//            
//        case .massas:
//            return "Massas"
//        
//        case .paesSalgados:
//            return "Pães &\nsalgados"
//            
//        case .peixesFrutosDoMar:
//            return "Peixes e frutos\ndo mar"
//            
//        case .saladasVegetais:
//            return "Legumes &\nvegetais"
//            
//        case .sopasCaldos:
//            return "Sopas"
//            
//        case .outro:
//            return "Outros"
//        }
//    }
//    
//    private var iconeCategoria: String {
//        switch categoria {
//        case .aves:
//            return "avesicone"
//            
//        case .bebidas:
//            return "cup.and.saucer.fill"
//            
//        case .carnes:
//            return "takeoutbag.and.cup.and.straw.fill"
//            
//        case .sobremesas:
//            return "birthday.cake.fill"
//            
//        case .arrozGraos:
//            return "leaf.fill"
//            
//        case .massas:
//            return "fork.knife"
//            
//        case .paesSalgados:
//            return "birthday.cake.fill"
//            
//        case .peixesFrutosDoMar:
//            return "fish.fill"
//            
//        case .saladasVegetais:
//            return "leaf.fill"
//            
//        case .sopasCaldos:
//            return "cup.and.saucer.fill"
//            
//        case .outro:
//            return "fork.knife"
//        }
//    }
//    
//    private var corCategoria: Color {
//        switch categoria {
//        case .aves:
//            return Color.brown
//            
//        case .bebidas:
//            return Color.cyan
//            
//        case .carnes:
//            return Color.red.opacity(0.55)
//            
//        case .sobremesas:
//            return Color.pink.opacity(0.65)
//            
//        case .arrozGraos:
//            return Color.orange
//            
//        case .massas:
//            return Color.yellow
//            
//        case .paesSalgados:
//            return Color.orange.opacity(0.8)
//            
//        case .peixesFrutosDoMar:
//            return Color.blue.opacity(0.65)
//            
//        case .saladasVegetais:
//            return Color.green.opacity(0.65)
//            
//        case .sopasCaldos:
//            return Color.red.opacity(0.7)
//            
//        case .outro:
//            return Color.gray
//        }
//    }
//}
//
//struct ReceitaCategoriasView: View {
//    
//    let categorias: [Categoria]
//    let selecionarCategoria: (Categoria) -> Void
//    
//    var body: some View {
//        VStack(
//            alignment: .leading,
//            spacing: 12
//        ) {
//            
//            Text("Categorias")
//                .font(
//                    .system(
//                        size: 22,
//                        weight: .semibold
//                    )
//                )
//            
//            ScrollView(
//                .horizontal,
//                showsIndicators: false
//            ) {
//                HStack(spacing: 12) {
//                    
//                    ForEach(categorias) { categoria in
//                        
//                        Button {
//                            selecionarCategoria(categoria)
//                        } label: {
//                            ReceitaCategoriaCardView(
//                                categoria: categoria
//                            )
//                        }
//                        .buttonStyle(.plain)
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ReceitaCategoriasView(categorias: Categoria.allCases) { _ in }
//}

//
//  ReceitaCategoriasView.swift
//  Simmer
//

import SwiftUI

struct ReceitaCategoriasView: View {
    
    let categorias: [Categoria]
    let selecionarCategoria: (Categoria) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Categorias")
                .font(.system(size: 22, weight: .semibold))
            
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

