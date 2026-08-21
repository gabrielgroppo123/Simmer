//
//  ObservacoesReceita.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 18/08/26.
//

import SwiftUI

struct ObservacoesReceita: View {
    
    private let receita: ReceitaModel
    private let service: ReceitaService
    private let abrirNovaObservacao: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var pesquisa = ""
    @State private var mostrandoNovaObservacao = false
    @State private var novaObservacao = ""
    
    @State private var observacoes: [ComentarioModel] = []
    
    @State private var mostrandoErro = false
    @State private var mensagemErro = ""
    
    // MARK: - Inicialização
    
    init(
            receita: ReceitaModel,
            service: ReceitaService,
            abrirNovaObservacao: Bool = false
        ) {
            self.receita = receita
            self.service = service
            self.abrirNovaObservacao = abrirNovaObservacao
        }
    
    // MARK: - Observações filtradas
    
    private var observacoesFiltradas: [ComentarioModel] {
        
        if pesquisa.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {
            return observacoes
        }
        
        return observacoes.filter {
            $0.descricao.localizedCaseInsensitiveContains(
                pesquisa
            )
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack(spacing: 0) {
                
                // MARK: Cabeçalho
                
                ObservacoesCabecalhoView(
                    voltar: {
                        dismiss()
                    },
                    adicionar: {
                        novaObservacao = ""
                        mostrandoNovaObservacao = true
                    }
                )
                
                // MARK: Lista de observações
                
                ScrollView {
                    
                    LazyVStack(
                        alignment: .leading,
                        spacing: 0
                    ) {
                        
                        ForEach(
                            observacoesFiltradas
                        ) { observacao in
                            
                            ObservacaoCardView(
                                observacao: observacao
                            )
                            .padding(.bottom, 28)
                        }
                        
                        // Espaço para a barra de pesquisa
                        
                        Color.clear
                            .frame(height: 70)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .scrollIndicators(.hidden)
            }
            
            // MARK: Barra de pesquisa
            
            ObservacoesBuscaView(
                pesquisa: $pesquisa
            )
        }
        .navigationBarBackButtonHidden(true)
        .background(
            Color(.systemBackground)
        )
        
        // MARK: Nova observação
        
        .sheet(
            isPresented: $mostrandoNovaObservacao
        ) {
            NovaObservacaoView(
                texto: $novaObservacao
            ) {
                adicionarObservacao()
            }
        }
        
        // MARK: Carregar observações
        
        .onAppear {
            carregarObservacoes()
            
            if abrirNovaObservacao {
                novaObservacao = ""
                mostrandoNovaObservacao = true
            }
        }
        
        // MARK: Alert
        
        .alert(
            "Erro",
            isPresented: $mostrandoErro
        ) {
            Button(
                "OK",
                role: .cancel
            ) {}
        } message: {
            Text(mensagemErro)
        }
    }
}

// MARK: - Core Data

private extension ObservacoesReceita {
    
    func carregarObservacoes() {
        
        do {
            
            observacoes = try service.buscarComentarios(
                receita: receita
            )
            
            print(
                "💬 \(observacoes.count) comentário(s) carregado(s)"
            )
            
        } catch {
            
            print(
                "❌ Erro ao carregar comentários: \(error)"
            )
        }
    }
    
    func adicionarObservacao() {
        
        let texto = novaObservacao.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !texto.isEmpty else {
            return
        }
        
        do {
            
            let comentario = try service.criarComentario(
                descricao: texto,
                receita: receita
            )
            
            observacoes.insert(
                comentario,
                at: 0
            )
            
            mostrandoNovaObservacao = false
            novaObservacao = ""
            
            print(
                "✅ Comentário salvo no Core Data!"
            )
            
        } catch {
            
            mensagemErro =
                "Não foi possível salvar a observação."
            
            mostrandoErro = true
            
            let nsError = error as NSError
            
            print("❌ ERRO AO SALVAR COMENTÁRIO")
            print("Domain: \(nsError.domain)")
            print("Code: \(nsError.code)")
            print(
                "Description: \(nsError.localizedDescription)"
            )
            print(
                "UserInfo: \(nsError.userInfo)"
            )
        }
    }
}

// MARK: - Preview

#Preview {
    
    let receita =
        PreviewSupport.criarDadosObservacoesPreview()
    
    NavigationStack {
        ObservacoesReceita(
            receita: receita,
            service: PreviewSupport.receitaService
        )
    }
}
