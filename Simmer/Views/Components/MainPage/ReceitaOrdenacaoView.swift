//
//  ReceitaOrdenacaoView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaOrdenacaoView: View {
    
    @Binding var ordenacao: ReceitaOrdenacao
    @Binding var direcao: ReceitaOrdenacao.Direcao
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Menu {
            
            // MARK: - Critério
            
            Button {
                ordenacao = .dataCriacao
            } label: {
                HStack {
                    Text("Data de criação")
                    
                    if ordenacao == .dataCriacao {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button {
                ordenacao = .tempoPreparo
            } label: {
                HStack {
                    Text("Tempo de preparo")
                    
                    if ordenacao == .tempoPreparo {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button {
                ordenacao = .titulo
            } label: {
                HStack {
                    Text("Título")
                    
                    if ordenacao == .titulo {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Divider()
            
            // MARK: - Direção
            
            Button {
                direcao = .crescente
            } label: {
                HStack {
                    Text(textoCrescente)
                    
                    if direcao == .crescente {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button {
                direcao = .decrescente
            } label: {
                HStack {
                    Text(textoDecrescente)
                    
                    if direcao == .decrescente {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
        } label: {
            Image(
                systemName: "arrow.up.arrow.down"
            )
            .font(.system(size: 18))
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            .frame(width: 40,height: 40)
            .glassEffect(.regular,in: Circle())
        }
        .accessibilityLabel("Ordenar receitas")
    }
    
    private var textoCrescente: String {
        
        switch ordenacao {
        case .dataCriacao:
            return "Mais antiga"
            
        case .tempoPreparo:
            return "Menor duração"
            
        case .titulo:
            return "A → Z"
        }
    }
    
    private var textoDecrescente: String {
        
        switch ordenacao {
        case .dataCriacao:
            return "Mais recente"
            
        case .tempoPreparo:
            return "Maior duração"
            
        case .titulo:
            return "Z → A"
        }
    }
}
