//
//  CadastrarReceita.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import SwiftUI
import PhotosUI

struct CadastrarReceita: View {
    
    private let service: ReceitaService
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var nome = ""
    @State private var categoria: Categoria = .outro
    @State private var foto: Data?
    @State private var porcoes = ""
    @State private var duracao = ""
    @State private var utensilios = ""
    @State private var modoPreparo = ""
    
    @State private var ingredientes: [IngredienteFormulario] = []
    
    @State private var fotoSelecionada: PhotosPickerItem?
    @State private var mostrandoErro = false
    @State private var mensagemErro = ""
    
    init(service: ReceitaService) {
        self.service = service
    }
    
    var body: some View {
        Form {
            
            // MARK: - Informações da receita
            
            Section("Informações da receita") {
                
                TextField(
                    "Nome da receita",
                    text: $nome
                )
                
                Picker(
                    "Categoria",
                    selection: $categoria
                ) {
                    ForEach(Categoria.allCases) { categoria in
                        Text(categoria.rawValue)
                            .tag(categoria)
                    }
                }
                
                TextField(
                    "Porções",
                    text: $porcoes
                )
                .keyboardType(.numberPad)
                
                TextField(
                    "Duração em minutos",
                    text: $duracao
                )
                .keyboardType(.numberPad)
                
                TextField(
                    "Utensílios",
                    text: $utensilios
                )
                
                TextField(
                    "Modo de preparo",
                    text: $modoPreparo,
                    axis: .vertical
                )
                .lineLimit(4...8)
            }
            
            // MARK: - Foto
            
            Section("Foto") {
                
                PhotosPicker(
                    selection: $fotoSelecionada,
                    matching: .images
                ) {
                    Label(
                        foto == nil
                            ? "Adicionar foto"
                            : "Alterar foto",
                        systemImage: "photo"
                    )
                }
                
                if let foto,
                   let imagem = UIImage(data: foto) {
                    
                    Image(uiImage: imagem)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12
                            )
                        )
                }
            }
            
            // MARK: - Ingredientes
            
            Section("Ingredientes") {
                
                ForEach($ingredientes) { $ingrediente in
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        TextField(
                            "Nome do ingrediente",
                            text: $ingrediente.nome
                        )
                        
                        HStack {
                            
                            TextField(
                                "Quantidade",
                                text: $ingrediente.quantidade
                            )
                            .keyboardType(.decimalPad)
                            
                            Picker(
                                "",
                                selection: $ingrediente.unidade
                            ) {
                                ForEach(
                                    UnidadeMedida.allCases
                                ) { unidade in
                                    Text(unidade.rawValue)
                                        .tag(unidade)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { offsets in
                    ingredientes.remove(atOffsets: offsets)
                }
                
                Button {
                    adicionarIngrediente()
                } label: {
                    Label(
                        "Adicionar ingrediente",
                        systemImage: "plus"
                    )
                }
            }
        }
        
        .navigationTitle("Cadastrar receita")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    salvarReceita()
                } label: {
                    Image(systemName: "checkmark")
                }
                .accessibilityLabel("Salvar receita")
            }
        }
        .task(id: fotoSelecionada) {
            await carregarFoto()
        }
        .alert(
            "Não foi possível salvar",
            isPresented: $mostrandoErro
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mensagemErro)
        }
    }
    
    // MARK: - Ingredientes
    
    private func adicionarIngrediente() {
        
        ingredientes.append(
            IngredienteFormulario()
        )
    }
    
    // MARK: - Foto
    
    private func carregarFoto() async {
        
        guard let fotoSelecionada else {
            return
        }
        
        do {
            foto = try await fotoSelecionada.loadTransferable(
                type: Data.self
            )
        } catch {
            print("❌ Erro ao carregar foto: \(error)")
        }
    }
    
    // MARK: - Salvar
    
    private func salvarReceita() {
        
        guard !nome.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            
            mostrarErro(
                "Informe o nome da receita."
            )
            
            return
        }
        
        guard let foto else {
            
            mostrarErro(
                "A foto da receita é obrigatória."
            )
            
            return
        }
        
        guard let porcoesInt = Int16(porcoes),
              porcoesInt > 0 else {
            
            mostrarErro(
                "Informe uma quantidade válida de porções."
            )
            
            return
        }
        
        guard let duracaoInt = Int64(duracao),
              duracaoInt > 0 else {
            
            mostrarErro(
                "Informe uma duração válida em minutos."
            )
            
            return
        }
        
        let novosIngredientes: [NovoIngrediente]
        
        do {
            novosIngredientes = try ingredientes.map {
                
                guard !($0.nome.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty) else {
                    
                    throw ErroCadastro.ingredienteSemNome
                }
                
                guard let quantidade = Double(
                    $0.quantidade.replacingOccurrences(
                        of: ",",
                        with: "."
                    )
                ),
                quantidade > 0 else {
                    
                    throw ErroCadastro.quantidadeInvalida
                }
                
                return NovoIngrediente(
                    nome: $0.nome,
                    quantidade: quantidade,
                    unidade: $0.unidade
                )
            }
        } catch {
            
            mostrarErro(
                "Verifique os dados dos ingredientes."
            )
            
            return
        }
        
        guard !novosIngredientes.isEmpty else {
            
            mostrarErro(
                "Adicione pelo menos um ingrediente."
            )
            
            return
        }
        
        let dados = NovaReceita(
            nome: nome,
            categoria: categoria,
            foto: foto,
            porcoes: porcoesInt,
            duracao: duracaoInt * 60,
            utensilios: utensilios.isEmpty
                ? nil
                : utensilios,
            modoPreparo: modoPreparo,
            ingredientes: novosIngredientes
        )
        
        do {
            
            _ = try service.criarReceita(dados)
            
            print("✅ Receita cadastrada com sucesso!")
            
            dismiss()
            
        } catch {
            
            mostrarErro(
                "Ocorreu um erro ao salvar a receita."
            )
            
            print(
                "❌ Erro ao cadastrar receita: \(error)"
            )
        }
    }
    
    private func mostrarErro(_ mensagem: String) {
        mensagemErro = mensagem
        mostrandoErro = true
    }
}

// MARK: - Modelo temporário do formulário

private struct IngredienteFormulario: Identifiable {
    
    let id = UUID()
    
    var nome = ""
    var quantidade = ""
    var unidade: UnidadeMedida = .unidades
}

// MARK: - Erros

private enum ErroCadastro: Error {
    case ingredienteSemNome
    case quantidadeInvalida
}

#Preview {
    NavigationStack {
        CadastrarReceita(
            service: PreviewSupport.receitaService
        )
    }
}
