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
    @State private var categoriaSelecionada: Categoria?
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    private let service: ReceitaService
    
    init(service: ReceitaService) {
        self.service = service
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
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
                            categoriaSelecionada = categoria
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
                                        ? (colorScheme == .dark ? .white : .black): .primary)
                                .font(.system(size: 18))
                                .frame(
                                    width: 40,
                                    height: 40
                                )
                                .glassEffect(.regular,in: Circle())
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
                                    .font(.system(size: 20))
                                    .foregroundStyle(.black)
                                    .frame(
                                        width: 40,
                                        height: 40
                                    )
                                    .background(Color.adicionarReceita)
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
                            
                            if receitasExibidas.isEmpty {
                                
                                VStack(spacing: 12) {
                                    
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.gray)
                                    
                                    Text("Você ainda não possui receitas")
                                        .font(.system(size: 18,weight: .semibold))
                                        .foregroundStyle(Color("Grafite"))
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Cadastre sua primeira receita para começar a montar seu caderno.")
                                        .font(.system(size: 15))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 80)
                                .padding(.horizontal, 30)
                                
                            } else {
                                
                                ForEach(receitasExibidas) { receita in
                                    
                                    NavigationLink {
                                        DetalhesReceita(receita: receita,service: service)
                                    } label: {
                                        ReceitaCardView(receita: receita)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.top, 18)
                        
                        // Espaço para a barra de pesquisa
                        
                        Color.clear
                            .frame(height: 70)
                    }
                    .padding(.horizontal, 16)
                }
                .navigationDestination(item: $categoriaSelecionada) { categoria in
                    CategoriaView(categoria: categoria,service: service)
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
            let resultado = try service.buscarReceitas(
                texto: textoBusca
            )
            
            print("🔎 Receitas encontradas: \(resultado.count)")
            
            for receita in resultado {
                print(
                    "🍰 \(receita.nome) | Categoria: \(receita.categoria.rawValue)"
                )
            }
            
            receitas = resultado
            
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
