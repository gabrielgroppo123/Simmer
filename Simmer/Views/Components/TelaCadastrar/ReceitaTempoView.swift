//
//  ReceitaTempoView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaTempoView: View {
    
    @Binding var duracao: String
    
    @State private var horasSelecionadas: Int = 0
    @State private var minutosSelecionados: Int = 30
    @State private var isPickerExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // MARK: - Linha Principal (Clicável)
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isPickerExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 20))
                        .frame(width: 28)
                        .foregroundStyle(.primary)
                    
                    Text("Tempo de preparo")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(duracao.isEmpty ? "0 min" : duracao)
                        .font(.system(size: 16))
                        .foregroundStyle(isPickerExpanded ? .blue : .primary)
                        .padding(.horizontal, 16)
                        .frame(height: 36)
                        .background(
                            isPickerExpanded
                                ? Color.blue.opacity(0.12)
                                : Color.gray.opacity(0.10)
                        )
                        .clipShape(Capsule())
                }
            }
            .buttonStyle(.plain)
            // MARK: - Menu Suspenso Sobreposto (Overlay)
            .overlay(alignment: .topTrailing) {
                if isPickerExpanded {
                    HStack(spacing: 0) {
                        Picker("Horas", selection: $horasSelecionadas) {
                            ForEach(0..<24, id: \.self) { hora in
                                Text("\(hora) h").tag(hora)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        
                        Picker("Minutos", selection: $minutosSelecionados) {
                            ForEach(0..<60, id: \.self) { minuto in
                                Text("\(minuto) min").tag(minuto)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    }
                    .frame(width: 260, height: 140)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(uiColor: .systemBackground))
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                    )
                    .offset(y: 44) // Desloca o menu para ficar logo abaixo do botão
                    .transition(.scale(scale: 0.95, anchor: .topTrailing).combined(with: .opacity))
                    .onChange(of: horasSelecionadas) { _, _ in atualizarDuracao() }
                    .onChange(of: minutosSelecionados) { _, _ in atualizarDuracao() }
                }
            }
        }
        .zIndex(isPickerExpanded ? 1 : 0) // Garante que o menu fique por cima de outras views na mesma tela
    }
    
    // MARK: - Formatação do Texto
    private func atualizarDuracao() {
        if horasSelecionadas == 0 && minutosSelecionados == 0 {
            duracao = ""
        } else if horasSelecionadas == 0 {
            duracao = "\(minutosSelecionados) min"
        } else if minutosSelecionados == 0 {
            duracao = "\(horasSelecionadas) h"
        } else {
            duracao = "\(horasSelecionadas)h \(minutosSelecionados)min"
        }
    }
}

// MARK: - Previews

#Preview("Menu Suspenso Sobreposto") {
    @Previewable @State var duracao = "45 min"
    
    VStack(spacing: 24) {
        ReceitaTempoView(duracao: $duracao)
        
        // Exemplo de elemento abaixo para testar a sobreposição
        Text("Conteúdo abaixo que será sobreposto")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
    }
    .padding()
}
