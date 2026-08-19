//
//  CategoriaView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 19/08/26.
//

import SwiftUI

struct CategoriaView: View {
    
    let categoria: Categoria
    private let service: ReceitaService
    
    @State private var receitas: [ReceitaModel] = []
    
    @State private var ordenacao: ReceitaOrdenacao = .dataCriacao
    @State private var direcao: ReceitaOrdenacao.Direcao = .decrescente
    
    @State private var somenteFavoritos = false
    @State private var textoBusca = ""
    
    init(
        categoria: Categoria,
        service: ReceitaService
    ) {
        self.categoria = categoria
        self.service = service
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                
                VStack(
                    alignment: .leading,
                    spacing: 0
                ) {
                    
                    // MARK: - Cabeçalho
                    
                    HStack(spacing: 12) {
                        
                        Text(nomeCategoria)
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
                        
                        // Adicionar receita
                        NavigationLink {
                            CadastrarReceita(
                                service: service,
                                categoriaInicial: categoria,
                                onSaved: {
                                    carregarReceitas()
                                }
                            )
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18))
                                .foregroundStyle(.black)
                                .frame(width: 40, height: 40)
                                .background(Color.orange)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel(
                            "Cadastrar nova receita"
                        )
                    }
                    .padding(.top, 24)
                    
                    // MARK: - Receitas
                    
                    LazyVStack(
                        spacing: 14
                    ) {
                        
                        ForEach(
                            receitasOrdenadas
                        ) { receita in
                            
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
                    .padding(.top, 20)
                    
                    Color.clear
                        .frame(height: 70)
                }
                .padding(.horizontal, 16)
            }
            
            // MARK: - Barra de pesquisa
            
            ReceitaBuscaView(
                textoBusca: $textoBusca,
                estaOuvindo: false,
                iniciarBuscaPorVoz: {
                    print("🎤 Busca por voz na categoria")
                }
            )
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
            .background(
                Color(.systemBackground)
                    .opacity(0.94)
            )
        }
        .navigationTitle("Categorias")
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            carregarReceitas()
        }
        .onChange(of: ordenacao) {
            aplicarFiltros()
        }
        .onChange(of: direcao) {
            aplicarFiltros()
        }
        .onChange(of: somenteFavoritos) {
            aplicarFiltros()
        }
        .onChange(of: textoBusca) {
            aplicarFiltros()
        }
    }
    
    // MARK: - Nome da categoria
    
    private var nomeCategoria: String {
        
        switch categoria {
            
        case .aves:
            return "Aves"
            
        case .bebidas:
            return "Bebidas"
            
        case .carnes:
            return "Carnes vermelhas"
            
        case .sobremesas:
            return "Doces"
            
        case .arrozGraos:
            return "Grãos & Leguminosas"
            
        case .massas:
            return "Massas"
            
        case .paesSalgados:
            return "Pães & salgados"
            
        case .peixesFrutosDoMar:
            return "Peixes e frutos do mar"
            
        case .saladasVegetais:
            return "Legumes & vegetais"
            
        case .sopasCaldos:
            return "Sopas"
            
        case .outro:
            return "Outros"
        }
    }
    
    // MARK: - Receitas ordenadas
    
    private var receitasOrdenadas: [ReceitaModel] {
        
        var resultado = receitas
        
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
            
            let todasReceitas = try service.buscarReceitas(
                texto: textoBusca
            )
            
            receitas = todasReceitas.filter {
                $0.categoria == categoria
            }
            
            aplicarFiltros()
            
        } catch {
            
            print(
                "❌ Erro ao carregar receitas da categoria: \(error)"
            )
        }
    }
    
    // MARK: - Filtros
    
    private func aplicarFiltros() {
        
        do {
            
            let todasReceitas = try service.buscarReceitas(
                texto: textoBusca
            )
            
            receitas = todasReceitas.filter { receita in
                
                guard receita.categoria == categoria else {
                    return false
                }
                
                if somenteFavoritos {
                    return receita.favorito
                }
                
                return true
            }
            
        } catch {
            
            print(
                "❌ Erro ao aplicar filtros: \(error)"
            )
        }
    }
}

#Preview {
    NavigationStack {
        CategoriaView(
            categoria: .sobremesas,
            service: PreviewSupport.receitaService
        )
    }
}
