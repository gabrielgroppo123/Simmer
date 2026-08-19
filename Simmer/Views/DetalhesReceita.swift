//
//  DetalhesReceita.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import SwiftUI
import UIKit

struct DetalhesReceita: View {
    
    let receita: ReceitaModel
    private let service: ReceitaService
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var receitaAtual: ReceitaModel
    @State private var mostrarAlertaExclusao = false
    
    init(
        receita: ReceitaModel,
        service: ReceitaService
    ) {
        self.receita = receita
        self.service = service
        _receitaAtual = State(initialValue: receita)
    }
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Foto
                
                if let imagem = UIImage(data: receitaAtual.foto) {
                    
                    Image(uiImage: imagem)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                    
                } else {
                    
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .frame(height: 250)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                        }
                }
                
                // MARK: - Informações principais
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(receitaAtual.nome)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(receitaAtual.categoria.rawValue)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 20) {
                        
                        if let porcoes = receitaAtual.porcoes {
                            Label(
                                "\(porcoes) porções",
                                systemImage: "person.2"
                            )
                        }
                        
                        Label(
                            formatarDuracao(
                                receitaAtual.duracao
                            ),
                            systemImage: "clock"
                        )
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)
                
                // MARK: - Ingredientes
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Ingredientes")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(
                        receitaAtual.ingredientes
                    ) { ingrediente in
                        
                        HStack {
                            
                            Text(ingrediente.nome)
                            
                            Spacer()
                            
                            Text(
                                "\(formatarQuantidade(ingrediente.quantidade)) " +
                                "\(ingrediente.unidade.rawValue)"
                            )
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Utensílios
                
                if let utensilios = receitaAtual.utensilios,
                   !utensilios.isEmpty {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {
                        
                        Text("Utensílios")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(utensilios)
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - Modo de preparo
                
                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {
                    
                    Text("Modo de preparo")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(receitaAtual.modoPreparo)
                }
                .padding(.horizontal)
                
                // MARK: - Data de criação
                
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    
                    Text("Criada em")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(
                        receitaAtual.dataCriacao ?? Date(),
                        style: .date
                    )
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // MARK: - Ações
                
                VStack(spacing: 12) {
                    
                    // Favoritar
                    Button {
                        alternarFavorito()
                    } label: {
                        Label(
                            receitaAtual.favorito
                                ? "Desfavoritar receita"
                                : "Favoritar receita",
                            systemImage:
                                receitaAtual.favorito
                                ? "star.fill"
                                : "star"
                        )
                    }
                    
                    // Editar
                    NavigationLink {
                        EditarReceita(
                            receita: receitaAtual,
                            service: service
                        )
                    } label: {
                        Label(
                            "Editar receita",
                            systemImage: "pencil"
                        )
                    }
                    
                    // Excluir
                    Button(role: .destructive) {
                        mostrarAlertaExclusao = true
                    } label: {
                        Label(
                            "Excluir receita",
                            systemImage: "trash"
                        )
                    }
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Receita")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Excluir receita?",
            isPresented: $mostrarAlertaExclusao
        ) {
            
            Button("Cancelar", role: .cancel) {
                // Não faz nada
            }
            
            Button(
                "Excluir",
                role: .destructive
            ) {
                excluirReceita()
            }
            
        } message: {
            
            Text(
                "Tem certeza que deseja excluir \"\(receitaAtual.nome)\"?"
            )
        }
    }
    
    // MARK: - Favorito
    
    private func alternarFavorito() {
        
        let novoValor = !receitaAtual.favorito
        
        do {
            
            try service.atualizarFavorito(
                receitaAtual,
                favorito: novoValor
            )
            
            receitaAtual = ReceitaModel(
                id: receitaAtual.id,
                nome: receitaAtual.nome,
                categoria: receitaAtual.categoria,
                favorito: novoValor,
                dataCriacao: receitaAtual.dataCriacao,
                foto: receitaAtual.foto,
                porcoes: receitaAtual.porcoes,
                duracao: receitaAtual.duracao,
                utensilios: receitaAtual.utensilios,
                modoPreparo: receitaAtual.modoPreparo,
                ingredientes: receitaAtual.ingredientes,
                comentarios: receitaAtual.comentarios
            )
            
            print(
                novoValor
                    ? "⭐ Receita favoritada!"
                    : "☆ Receita desfavoritada!"
            )
            
        } catch {
            
            print(
                "❌ Erro ao atualizar favorito: \(error)"
            )
        }
    }
    
    // MARK: - Exclusão
    
    private func excluirReceita() {
        
        do {
            
            try service.deletarReceita(
                receitaAtual
            )
            
            print(
                "🗑️ Receita excluída: \(receitaAtual.nome)"
            )
            
            dismiss()
            
        } catch {
            
            print(
                "❌ Erro ao excluir receita: \(error)"
            )
        }
    }
    
    // MARK: - Formatação da duração
    
    private func formatarDuracao(
        _ duracao: Int64
    ) -> String {
        
        let minutos = duracao / 60
        
        if minutos < 60 {
            return "\(minutos) min"
        }
        
        let horas = minutos / 60
        let minutosRestantes = minutos % 60
        
        if minutosRestantes == 0 {
            return "\(horas) h"
        }
        
        return "\(horas) h \(minutosRestantes) min"
    }
    
    // MARK: - Formatação da quantidade
    
    private func formatarQuantidade(
        _ quantidade: Double
    ) -> String {
        
        if quantidade.truncatingRemainder(
            dividingBy: 1
        ) == 0 {
            
            return String(
                Int(quantidade)
            )
        }
        
        return String(quantidade)
    }
}

#Preview {
    NavigationStack {
        
        DetalhesReceita(
            receita: ReceitaModel(
                id: UUID(),
                nome: "Bolo de Chocolate",
                categoria: .doces,
                favorito: false,
                dataCriacao: Date(),
                foto: UIImage(
                    systemName: "fork.knife.circle.fill"
                )!.pngData()!,
                porcoes: 8,
                duracao: 2400,
                utensilios: "Forma e batedeira",
                modoPreparo:
                    "Misture todos os ingredientes e asse por 40 minutos.",
                ingredientes: [
                    IngredienteModel(
                        id: UUID(),
                        nome: "Ovos",
                        quantidade: 3,
                        unidade: .unidades
                    ),
                    IngredienteModel(
                        id: UUID(),
                        nome: "Farinha de trigo",
                        quantidade: 200,
                        unidade: .gramas
                    )
                ],
                comentarios: []
            ),
            service: PreviewSupport.receitaService
        )
    }
}
