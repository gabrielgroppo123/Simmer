//
//  ReceitaCardView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI
import UIKit

struct ReceitaCardView: View {
    
    let receita: ReceitaModel
    
    var body: some View {
        HStack(spacing: 12) {
            
            // MARK: - Imagem
            imagemReceita
            
            // MARK: - Informações
            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                Text(receita.nome)
                    .font(
                        .system(
                            size: 16,
                            weight: .medium
                        )
                    )
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(
                        systemName: "clock.fill"
                    )
                    .font(.system(size: 10))
                    
                    Text(
                        textoDuracao(
                            receita.duracao
                        )
                    )
                    
                    if receita.favorito {
                        Image(
                            systemName: "heart.fill"
                        )
                        
                        Text("Favorito")
                    }
                }
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            
            // MARK: - Navegação
            Image(
                systemName: "chevron.right"
            )
            .font(
                .system(
                    size: 16,
                    weight: .regular
                )
            )
            .foregroundStyle(.primary)
        }
        .padding(12)
        .frame(height: 92)
        .background(
            RoundedRectangle(
                cornerRadius: 17
            )
            .fill(Color("CardReceita"))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 17)
            .stroke(Color("TracadoCardReceita"), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.06), radius: 5, y: 2)
    }
    
    // MARK: - Imagem
    private var imagemReceita: some View {
        Group {
            if let imagem = UIImage(
                data: receita.foto
            ) {
                Image(uiImage: imagem)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.gray.opacity(0.15)
                    Image(
                        systemName: "photo"
                    )
                    .foregroundStyle(.secondary)
                }
            }
        }
        .frame(
            width: 60,
            height: 60
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
    }
    
    // MARK: - Duração
    private func textoDuracao(
        _ duracaoEmSegundos: Int64
    ) -> String {
        guard duracaoEmSegundos > 0 else {
            return "Não informado"
        }
        
        let totalMinutos = duracaoEmSegundos / 60
        let horas = totalMinutos / 60
        let minutosRestantes = totalMinutos % 60
        
        if horas > 0 {
            if minutosRestantes > 0 {
                return "\(horas)h \(minutosRestantes)min"
            }
            return "\(horas)h"
        }
        
        return "\(minutosRestantes)min"
    }
}

