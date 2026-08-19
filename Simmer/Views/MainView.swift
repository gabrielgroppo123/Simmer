//
//  MainView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 14/08/26.
//

import SwiftUI

struct MainView: View {
    
    @State private var receitas: [ReceitaModel] = []
    @State private var textoBusca = ""
    @State private var somenteFavoritos = false
    @State private var ordenacao: ReceitaOrdenacao = .dataCriacao
    @State private var direcao: ReceitaOrdenacao.Direcao = .decrescente
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    private let service: ReceitaService
    
    init(service: ReceitaService) {
        self.service = service
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottom) {
                
                ScrollView {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 0
                    ) {
                        
                        // MARK: - Categorias
                        
                        ReceitaCategoriasView(
                            categorias: Categoria.allCases
                        ) { categoria in
                            
                            print(
                                "📂 Categoria selecionada: \(categoria.rawValue)"
                            )
                        }
                        .padding(.top, 28)
                        
                        // MARK: - Suas receitas
                        
                        HStack(spacing: 12) {
                            
                            Text("Suas Receitas")
                                .font(
                                    .system(
                                        size: 22,
                                        weight: .semibold
                                    )
                                )
                            
                            Spacer()
                            
                            // Favoritos
                            Button {
                                somenteFavoritos.toggle()
                            } label: {
                                Image(
                                    systemName:
                                        somenteFavoritos
                                        ? "heart.fill"
                                        : "heart"
                                )
                                .foregroundStyle(
                                    somenteFavoritos
                                    ? .black
                                    : .primary
                                )
                                .font(.system(size: 18))
                                .frame(
                                    width: 40,
                                    height: 40
                                )
                                .background(
                                    Color.gray.opacity(0.08)
                                )
                                .clipShape(Circle())
                            }
                            .accessibilityLabel(
                                somenteFavoritos
                                ? "Mostrar todas as receitas"
                                : "Mostrar somente favoritas"
                            )
                            
                            // Ordenação
                            ReceitaOrdenacaoView(
                                ordenacao: $ordenacao,
                                direcao: $direcao
                            )
                            
                            // Nova receita
                            NavigationLink {
                                CadastrarReceita(
                                    service: service,
                                    onSaved: {
                                        carregarReceitas()
                                    }
                                )
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                    .frame(
                                        width: 40,
                                        height: 40
                                    )
                                    .background(
                                        Color.orange
                                    )
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel(
                                "Cadastrar nova receita"
                            )
                        }
                        .padding(.top, 52)
                        
                        // MARK: - Lista de receitas
                        
                        LazyVStack(
                            spacing: 14
                        ) {
                            
                            ForEach(receitas) { receita in
                                
                                NavigationLink {
                                    DetalhesReceita(
                                        receita: receita,
                                        service: service
                                    )
                                } label: {
                                    ReceitaCardView(
                                        receita: receita
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 18)
                        
                        // Espaço para a barra de pesquisa
                        
                        Color.clear
                            .frame(height: 70)
                    }
                    .padding(.horizontal, 16)
                }
                
                // MARK: - Barra de pesquisa
                
                ReceitaBuscaView(
                    textoBusca: $textoBusca,
                    estaOuvindo:
                        speechRecognizer.estaOuvindo,
                    iniciarBuscaPorVoz:
                        iniciarBuscaPorVoz
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .background(
                    Color(.systemBackground)
                        .opacity(0.94)
                )
            }
            .background(
                Color(.systemBackground)
            )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            carregarReceitas()
        }
        .onChange(of: textoBusca) {
            carregarReceitas()
        }
        .onChange(
            of: speechRecognizer.textoReconhecido
        ) {
            textoBusca =
                speechRecognizer.textoReconhecido
        }
    }
    
    private var receitasExibidas: [ReceitaModel] {
        
        var resultado = receitas
        
        if somenteFavoritos {
            resultado = resultado.filter {
                $0.favorito
            }
        }
        
        switch ordenacao {
            
        case .dataCriacao:
            resultado.sort {
                if direcao == .decrescente {
                    return $0.dataCriacao ?? Date() > $1.dataCriacao ?? Date()
                } else {
                    return $0.dataCriacao ?? Date() < $1.dataCriacao ?? Date()
                }
            }
            
        case .tempoPreparo:
            resultado.sort {
                if direcao == .crescente {
                    return $0.duracao < $1.duracao
                } else {
                    return $0.duracao > $1.duracao
                }
            }
            
        case .titulo:
            resultado.sort {
                if direcao == .crescente {
                    return $0.nome.localizedCaseInsensitiveCompare(
                        $1.nome
                    ) == .orderedAscending
                } else {
                    return $0.nome.localizedCaseInsensitiveCompare(
                        $1.nome
                    ) == .orderedDescending
                }
            }
        }
        
        return resultado
    }
    
    // MARK: - Carregar receitas
    
    private func carregarReceitas() {
        
        do {
            receitas = try service.buscarReceitas(
                texto: textoBusca
            )
        } catch {
            print(
                "❌ Erro ao buscar receitas: \(error)"
            )
        }
    }
    
    // MARK: - Busca por voz
    
    private func iniciarBuscaPorVoz() {
        
        if speechRecognizer.estaOuvindo {
            speechRecognizer.pararReconhecimento()
            return
        }
        
        Task {
            
            let permitido =
                await speechRecognizer.solicitarPermissao()
            
            guard permitido else {
                print(
                    "❌ Permissão para microfone ou reconhecimento negada."
                )
                return
            }
            
            speechRecognizer.iniciarReconhecimento()
        }
    }
}

#Preview {
    MainView(
        service: PreviewSupport.receitaService
    )
}
