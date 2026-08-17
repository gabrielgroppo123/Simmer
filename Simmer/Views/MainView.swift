//
//  MainView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 14/08/26.
//

import SwiftUI
import UIKit
import Speech

struct MainView: View {
    
    @State private var receitas: [ReceitaModel] = []
    @State private var textoBusca = ""
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    private let service: ReceitaService
    
    init(service: ReceitaService) {
        self.service = service
    }
    
    private var barraDePesquisa: some View {
        HStack(spacing: 10) {
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField(
                "Buscar receitas",
                text: $textoBusca
            )
            
            Button {
                iniciarBuscaPorVoz()
            } label: {
                Image(
                    systemName: speechRecognizer.estaOuvindo
                        ? "mic.fill"
                        : "mic"
                )
            }
            .accessibilityLabel(
                speechRecognizer.estaOuvindo
                    ? "Parar pesquisa por voz"
                    : "Pesquisar por voz"
            )
        }
        .padding(.horizontal, 14)
        .frame(height: 44)
        .background(.gray.opacity(0.15))
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                LazyVStack(spacing: 16) {
                    
                    ForEach(receitas) { receita in
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            if let imagem = UIImage(data: receita.foto) {
                                Image(uiImage: imagem)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .frame(maxWidth: .infinity)
                                    .clipped()
                            } else {
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(height: 180)
                                    .overlay {
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundStyle(.gray)
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text(receita.nome)
                                    .font(.headline)
                                
                                Text(receita.categoria.rawValue)
                                    .font(.subheadline)
                                
                                Button("Ver detalhes") {
                                    print(
                                        "📖 Abrir receita: \(receita.nome)"
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.background)
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 5
                                )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            .navigationTitle("Simmer")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CadastrarReceita(
                            service: service
                        )
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Cadastrar nova receita")
                }
            }
            
            barraDePesquisa
                .padding(.horizontal)
                .padding(.top)
        }
        .onAppear {
            carregarReceitas()
        }
        .onChange(of: textoBusca) {
            carregarReceitas()
        }
        .onChange(of: speechRecognizer.textoReconhecido) {
            textoBusca = speechRecognizer.textoReconhecido
        }
    }
    
    private func carregarReceitas() {
        
        do {
            receitas = try service.buscarReceitas(
                texto: textoBusca
            )
        } catch {
            print("❌ Erro ao buscar receitas: \(error)")
        }
    }
    
    private func iniciarBuscaPorVoz() {
        
        if speechRecognizer.estaOuvindo {
            speechRecognizer.pararReconhecimento()
            return
        }
        
        Task {
            let permitido = await speechRecognizer.solicitarPermissao()
            
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
