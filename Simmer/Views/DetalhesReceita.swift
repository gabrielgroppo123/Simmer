//
//  DetalhesReceita.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import SwiftUI
import UIKit

struct DetalhesReceita: View {
    
    // MARK: - Propriedades
    
    let receita: ReceitaModel
    private let service: ReceitaService
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var receitaAtual: ReceitaModel
    @State private var mostrarAlertaExclusao = false
    
    // Processa a String de utensílios transformando em um Array de Strings
    private var listaUtensilios: [String] {
        guard let utensilios = receitaAtual.utensilios, !utensilios.isEmpty else { return [] }
        return utensilios
            .components(separatedBy: CharacterSet(charactersIn: "\n,"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    // MARK: - Inicializador
    
    init(
        receita: ReceitaModel,
        service: ReceitaService
    ) {
        self.receita = receita
        self.service = service
        _receitaAtual = State(initialValue: receita)
    }
    
    // MARK: - Body
    
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
                
                // MARK: - Informações Principais
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Button {
                        alternarFavorito()
                    } label: {
                        Label(
                            receitaAtual.favorito ? "Desfavoritar" : "Favoritar",
                            systemImage: receitaAtual.favorito ? "heart.fill" : "heart"
                        )
                    }
                    .tint(.primary)
                    
                    // Componente de exibição visual do Nome (Não Editável)
                    ReceitaCampoNomeExibicaoView(nome: receitaAtual.nome)
                    
                    // Card com Meta-informações (Data de Criação, Tempo e Porções)
                    CardDetalhesView(paddingVertical: 20, paddingHorizontal: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // 1. Data de Criação
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.title3)
                                    .frame(width: 24)
                                
                                (Text("Receita criada em: ")
                                    .fontWeight(.bold) +
                                 Text(receitaAtual.dataCriacao ?? Date(), style: .date)
                                    .fontWeight(.regular))
                                .font(.body)
                            }
                            
                            // 2. Tempo de Preparo
                            HStack(spacing: 12) {
                                Image(systemName: "clock")
                                    .font(.title3)
                                    .frame(width: 24)
                                
                                (Text("Tempo de preparo: ")
                                    .fontWeight(.bold) +
                                 Text(formatarDuracao(receitaAtual.duracao))
                                    .fontWeight(.regular))
                                .font(.body)
                            }
                            
                            // 3. Porções
                            if let porcoes = receitaAtual.porcoes {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.2")
                                        .font(.title3)
                                        .frame(width: 24)
                                    
                                    (Text("Porções: ")
                                        .fontWeight(.bold) +
                                     Text("\(porcoes)")
                                        .fontWeight(.regular))
                                    .font(.body)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Ingredientes
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Ingredientes")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(receitaAtual.ingredientes) { ingrediente in
                        
                        CardDetalhesView(paddingVertical: 14, paddingHorizontal: 16) {
                            HStack {
                                
                                Text(ingrediente.nome)
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Text(formatarQuantidade(ingrediente.quantidade))
                                    Text(ingrediente.unidade.rawValue)
                                }
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Modo de Preparo
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Modo de Fazer")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    CardDetalhesView {
                        Text(receitaAtual.modoPreparo)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Utensílios
                
                if !listaUtensilios.isEmpty {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Utensílios")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ForEach(listaUtensilios, id: \.self) { utensilio in
                            CardDetalhesView(paddingVertical: 14, paddingHorizontal: 16) {
                                Text(utensilio)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - Observações (Comentários da Receita)
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    NavigationLink {
                        ObservacoesReceita(
                            receita: receitaAtual,
                            service: service)
                    } label: {
                        HStack(spacing: 6) {
                            Text("Observações")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .tint(.primary)
                    }
                    .padding(.horizontal)
                    
                    if receitaAtual.comentarios.isEmpty {
                        
                        // Estado vazio para manter a seção visível
                        CardDetalhesView(paddingVertical: 16, paddingHorizontal: 20) {
                            Text("Sugestão: descreva não só sabores, mas sentimentos, expectativas, dificuldades no seu processo com a receita. ")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        
                    } else {
                        
                        // Carrossel horizontal de comentários
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(receitaAtual.comentarios.prefix(3)) { comentario in
                                    CardObservacaoDetalhes(comentario: comentario)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Receita")
        .navigationBarTitleDisplayMode(.inline)
        
        // MARK: - Sincronização pós-edição
        .onAppear {
            atualizarDadosLocais()
        }
        
        // MARK: - Toolbar
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    
                    // Compartilhar
                    ShareLink(
                        item: receitaAtual.nome,
                        subject: Text(receitaAtual.nome),
                        message: Text("Confira essa receita de \(receitaAtual.nome) no Simmer!")
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    // Menu de Ações (Padrão iOS)
                    Menu {
                        
                        NavigationLink {
                            EditarReceita(
                                receita: receitaAtual,
                                service: service
                            )
                        } label: {
                            Label("Editar receita", systemImage: "pencil")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            mostrarAlertaExclusao = true
                        } label: {
                            Label("Excluir receita", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        
        // MARK: - Alerta Exclusão
        
        .alert(
            "Excluir receita?",
            isPresented: $mostrarAlertaExclusao
        ) {
            
            Button("Cancelar", role: .cancel) { }
            
            Button("Excluir", role: .destructive) {
                excluirReceita()
            }
            
        } message: {
            Text("Tem certeza que deseja excluir \"\(receitaAtual.nome)\"?")
        }
    }
    
    // MARK: - Métodos Auxiliares e Lógica
    
    private func atualizarDadosLocais() {
        if let receitaAtualizada = try? service.buscarReceita(id: receitaAtual.id) {
            self.receitaAtual = receitaAtualizada
        }
    }
    
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
            
        } catch {
            print("❌ Erro ao atualizar favorito: \(error)")
        }
    }
    
    private func excluirReceita() {
        do {
            try service.deletarReceita(receitaAtual)
            dismiss()
        } catch {
            print("❌ Erro ao excluir receita: \(error)")
        }
    }
    
    private func formatarDuracao(_ duracao: Int64) -> String {
        let minutos = duracao / 60
        if minutos < 60 { return "\(minutos) min" }
        
        let horas = minutos / 60
        let minutosRestantes = minutos % 60
        
        if minutosRestantes == 0 { return "\(horas) h" }
        return "\(horas) h \(minutosRestantes) min"
    }
    
    private func formatarQuantidade(_ quantidade: Double) -> String {
        if quantidade.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(quantidade))
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
