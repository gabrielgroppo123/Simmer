//
//  EditarReceita.swift
//  Simmer
//

import SwiftUI
import PhotosUI
import UIKit

struct EditarReceita: View {
    
    let receita: ReceitaModel
    private let service: ReceitaService
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var nome: String
    @State private var categoria: Categoria
    @State private var foto: Data
    @State private var porcoes: String
    @State private var duracao: String
    @State private var utensilios: String
    @State private var modoPreparo: String
    
    @State private var ingredientes: [IngredienteFormulario]
    
    @State private var fotoSelecionada: PhotosPickerItem?
    @State private var mostrandoErro = false
    @State private var mensagemErro = ""
    
    init(
        receita: ReceitaModel,
        service: ReceitaService
    ) {
        self.receita = receita
        self.service = service
        
        _nome = State(initialValue: receita.nome)
        _categoria = State(initialValue: receita.categoria)
        _foto = State(initialValue: receita.foto)
        
        _porcoes = State(
            initialValue: receita.porcoes.map(String.init) ?? ""
        )
        
        _duracao = State(
            initialValue: "\(receita.duracao / 60)"
        )
        
        _utensilios = State(
            initialValue: receita.utensilios ?? ""
        )
        
        _modoPreparo = State(
            initialValue: receita.modoPreparo
        )
        
        let ingredientesIniciais = receita.ingredientes.map {
            IngredienteFormulario(
                id: $0.id,
                nome: $0.nome,
                quantidade: "\($0.quantidade)",
                unidade: $0.unidade
            )
        }
        
        _ingredientes = State(
            initialValue: ingredientesIniciais
        )
    }
    
    var body: some View {
        Form {
            
            // MARK: - Informações
            
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
                        "Alterar foto",
                        systemImage: "photo"
                    )
                }
                
                if let imagem = UIImage(data: foto) {
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
                    
                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {
                        
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
                    ingredientes.remove(
                        atOffsets: offsets
                    )
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
        .navigationTitle("Editar receita")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    salvarAlteracoes()
                } label: {
                    Image(systemName: "checkmark")
                }
                .accessibilityLabel(
                    "Salvar alterações"
                )
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
            if let novaFoto = try await fotoSelecionada
                .loadTransferable(type: Data.self) {
                
                foto = novaFoto
            }
        } catch {
            print(
                "❌ Erro ao carregar foto: \(error)"
            )
        }
    }
    
    // MARK: - Salvar
    
    private func salvarAlteracoes() {
        
        guard !nome.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            
            mostrarErro(
                "Informe o nome da receita."
            )
            
            return
        }
        
        guard !foto.isEmpty else {
            
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
                    
                    throw ErroEdicao.ingredienteSemNome
                }
                
                guard let quantidade = Double(
                    $0.quantidade.replacingOccurrences(
                        of: ",",
                        with: "."
                    )
                ),
                quantidade > 0 else {
                    
                    throw ErroEdicao.quantidadeInvalida
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
        
        do {
            
            try service.atualizarReceita(
                receita,
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
            
            print(
                "✅ Receita atualizada com sucesso!"
            )
            
            dismiss()
            
        } catch {
            
            mostrarErro(
                "Ocorreu um erro ao atualizar a receita."
            )
            
            print(
                "❌ Erro ao atualizar receita: \(error)"
            )
        }
    }
    
    private func mostrarErro(_ mensagem: String) {
        mensagemErro = mensagem
        mostrandoErro = true
    }
    
    private func formatarQuantidade(
        _ quantidade: Double
    ) -> String {
        
        if quantidade.truncatingRemainder(
            dividingBy: 1
        ) == 0 {
            return String(Int(quantidade))
        }
        
        return String(quantidade)
    }
}



// MARK: - Erros

private enum ErroEdicao: Error {
    case ingredienteSemNome
    case quantidadeInvalida
}

#Preview {
    NavigationStack {
        EditarReceita(
            receita: ReceitaModel(
                id: UUID(),
                nome: "Bolo de Chocolate",
                categoria: .sobremesas,
                favorito: false,
                dataCriacao: Date(),
                foto: UIImage(
                    systemName: "fork.knife.circle.fill"
                )!.pngData()!,
                porcoes: 8,
                duracao: 2400,
                utensilios: "Forma e batedeira",
                modoPreparo: "Misture todos os ingredientes e asse por 40 minutos.",
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
