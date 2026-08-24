//
//  ReceitaCategoriaCardView.swift
//  Simmer
//
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 19/08/26.
//

import SwiftUI

struct ReceitaCategoriaCardView: View {
    
    let categoria: Categoria
    
    var body: some View {
        VStack(alignment: .leading) {
            
        
            Text(nomeCategoria)
                .font(.custom("Alexandria-Bold", size: 14))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Image(iconeCategoria)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
            }
        }
        .padding(12)
        .frame(width: 128, height: 90)
        .background(gradienteCategoria)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.6), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    private var gradienteCategoria: LinearGradient {
        LinearGradient(
            colors: coresGradiente,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    private var coresGradiente: [Color] {
        switch categoria {
        case .aves:
            return [
                Color(red: 0.62, green: 0.28, blue: 0.10),
                Color(red: 0.90, green: 0.58, blue: 0.35)
            ]
            
        case .bebidas:
            return [
                Color(red: 0.18, green: 0.68, blue: 0.74),
                Color(red: 0.64, green: 0.90, blue: 0.94)
            ]
            
        case .carnes:
            return [
                Color(red: 0.32, green: 0.10, blue: 0.08),
                Color(red: 0.55, green: 0.22, blue: 0.16)
            ]
            
        case .doces:
            return [
                Color(red: 0.95, green: 0.42, blue: 0.44),
                Color(red: 0.98, green: 0.82, blue: 0.80)
            ]
            
        case .arrozGraos:
            return [
                Color(red: 0.92, green: 0.55, blue: 0.16),
                Color(red: 0.98, green: 0.78, blue: 0.48)
            ]
            
        case .massas:
            return [
                Color(red: 0.96, green: 0.72, blue: 0.16),
                Color(red: 0.99, green: 0.90, blue: 0.60)
            ]
            
        case .paesSalgados:
            return [
                Color(red: 0.75, green: 0.38, blue: 0.12),
                Color(red: 0.92, green: 0.60, blue: 0.28)
            ]
            
        case .peixesFrutosDoMar:
            return [
                Color(red: 0.28, green: 0.46, blue: 0.55),
                Color(red: 0.68, green: 0.82, blue: 0.86)
            ]
            
        case .saladasVegetais:
            return [
                Color(red: 0.38, green: 0.48, blue: 0.12),
                Color(red: 0.74, green: 0.82, blue: 0.28)
            ]
            
        case .sopasCaldos:
            return [
                Color(red: 0.62, green: 0.18, blue: 0.12),
                Color(red: 0.85, green: 0.42, blue: 0.28)
            ]
            
        case .outro:
            return [
                Color(red: 0.42, green: 0.42, blue: 0.44),
                Color(red: 0.82, green: 0.82, blue: 0.85)
            ]
        }
    }
    
    private var nomeCategoria: String {
        switch categoria {
        case .aves: return "Aves"
        case .bebidas: return "Bebidas"
        case .carnes: return "Carnes vermelhas"
        case .doces: return "Doces"
        case .arrozGraos: return "Grãos & Leguminosas"
        case .massas: return "Massas"
        case .paesSalgados: return "Pães & salgados"
        case .peixesFrutosDoMar: return "Peixes & frutos do mar"
        case .saladasVegetais: return "Legumes & vegetais"
        case .sopasCaldos: return "Sopas"
        case .outro: return "Outros"
        }
    }
    
    private var iconeCategoria: String {
        switch categoria {
        case .aves: return "avesicone"
        case .bebidas: return "bebidasicone"
        case .carnes: return "carnesvermelhasicone"
        case .doces: return "docesicone"
        case .arrozGraos: return "graoseleguminosasicone"
        case .massas: return "massaicone"
        case .paesSalgados: return "paesesalgadosicone"
        case .peixesFrutosDoMar: return "frutosdomaricone"
        case .saladasVegetais: return "legumesevegetaisicone"
        case .sopasCaldos: return "sopasicone"
        case .outro: return "outrosicone"
        }
    }
}

#Preview {
    ReceitaCategoriaCardView(categoria: .sopasCaldos)
        .padding()
}
