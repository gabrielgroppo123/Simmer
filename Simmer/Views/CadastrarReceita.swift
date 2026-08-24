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
    private let onSaved: () -> Void

    init(
        service: ReceitaService,
        categoriaInicial: Categoria? = nil,
        onSaved: @escaping () -> Void = {}
    ) {
        self.service = service
        self.onSaved = onSaved
        
        _categoria = State(
            initialValue: categoriaInicial
        )
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var nome = ""
    @State private var categoria: Categoria?
    @State private var foto: Data?
    @State private var porcoes = ""
    @State private var duracao = ""
    @State private var utensilios: [String] = []
    @State private var modoPreparo = ""
    @State private var observacao = ""
    
    @State private var ingredientes: [IngredienteFormulario] = []
    
    @State private var fotoSelecionada: PhotosPickerItem?
    @State private var mostrandoErro = false
    @State private var mensagemErro = ""
    
    var body: some View {
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                
                ReceitaFotoView(
                    foto: $foto,
                    fotoSelecionada: $fotoSelecionada
                )
                .padding(.top, 18)
                .padding(.leading, 70)
                
                ReceitaCampoNomeView(
                    nome: $nome
                )
                .padding(.top, 46)
                
                ReceitaTempoView(
                    duracao: $duracao
                )
                .padding(.top, 34)
                
                ReceitaPorcoesView(
                    porcoes: $porcoes
                )
                .padding(.top, 26)
                
                ReceitaCategoriaView(
                    categoria: $categoria
                )
                .padding(.top, 22)
                
                ReceitaIngredientesView(
                    ingredientes: $ingredientes
                )
                .padding(.top, 48)
                
                ReceitaModoPreparoView(
                    modoPreparo: $modoPreparo
                )
                .padding(.top, 48)
                
                ReceitaUtensiliosView(
                    utensilios: $utensilios
                )
                .padding(.top, 46)
                
                ReceitaObservacoesView(
                    observacao: $observacao
                )
                .padding(.top, 46)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .fecharTecladoAoTocarFora()
        .scrollIndicators(.hidden)
        .background(
            Color(.systemBackground)
        )
        .navigationTitle("Nova Receita")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button {
                    salvarReceita()
                    
                } label: {
                    Image(
                        systemName: "checkmark"
                    )
                }
                .accessibilityLabel(
                    "Salvar receita"
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
            Button(
                "OK",
                role: .cancel
            ) {}
        } message: {
            Text(mensagemErro)
        }
    }
}

// MARK: - Ações

private extension CadastrarReceita {
    
    func adicionarIngrediente() {
        ingredientes.append(
            IngredienteFormulario()
        )
    }
    
    func adicionarUtensilio() {
        utensilios.append("")
    }
    
    func removerUtensilio(no indice: Int) {
        
        guard utensilios.indices.contains(
            indice
        ) else {
            return
        }
        
        utensilios.remove(
            at: indice
        )
    }
    
    func aumentarPorcoes() {
        
        let atual = Int16(
            porcoes
        ) ?? 0
        
        porcoes = String(
            atual + 1
        )
    }
    
    func diminuirPorcoes() {
        
        let atual = Int16(
            porcoes
        ) ?? 0
        
        guard atual > 0 else {
            return
        }
        
        let novoValor = atual - 1
        
        if novoValor == 0 {
            porcoes = ""
        } else {
            porcoes = String(
                novoValor
            )
        }
    }
    
    func carregarFoto() async {
        
        guard let fotoSelecionada else {
            return
        }
        
        do {
            
            foto = try await fotoSelecionada
                .loadTransferable(
                    type: Data.self
                )
            
        } catch {
            
            print(
                "❌ Erro ao carregar foto: \(error)"
            )
        }
    }
}

// MARK: - Persistência

private extension CadastrarReceita {
    
    func salvarReceita() {
        
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
        
        // Porções são opcionais.
        let porcoesInt: Int16?
        
        if porcoes.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {
            
            porcoesInt = nil
            
        } else {
            
            guard let valor = Int16(porcoes),
                  valor > 0 else {
                
                mostrarErro(
                    "Informe uma quantidade válida de porções."
                )
                
                return
            }
            
            porcoesInt = valor
        }
        
        guard let duracaoInt = converterDuracaoParaSegundos(duracao),
              duracaoInt > 0 else {
            
            mostrarErro(
                "Informe um tempo de preparo válido."
            )
            
            return
        }
        
        guard !modoPreparo.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            
            mostrarErro(
                "Informe o modo de preparo."
            )
            
            return
        }
        
        // Ingredientes
        
        guard !ingredientes.isEmpty else {
            
            mostrarErro(
                "Adicione pelo menos um ingrediente."
            )
            
            return
        }
        
        let novosIngredientes: [NovoIngrediente]
        
        do {
            
            novosIngredientes = try ingredientes.map {
                
                guard !$0.nome.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty else {
                    
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
        
        // Utensílios
        
        let utensiliosString = utensilios
            .map {
                $0.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            }
            .filter {
                !$0.isEmpty
            }
            .joined(
                separator: "\n"
            )
        
        guard let categoria else {
            mostrarErro(
                "Escolha uma categoria para a receita."
            )
            return
        }
        
        let dados = NovaReceita(
            nome: nome,
            categoria: categoria,
            foto: foto,
            porcoes: porcoesInt,
            duracao: duracaoInt, // Corrigido: sem o "* 60"
            utensilios: utensiliosString.isEmpty
                ? nil
                : utensiliosString,
            modoPreparo: modoPreparo,
            ingredientes: novosIngredientes
        )
        
        do {
            
            let receitaCriada = try service.criarReceita(dados)
            
            let textoObservacao = observacao.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            
            if !textoObservacao.isEmpty {
                
                print("📝 Tentando salvar observação:")
                print(textoObservacao)
                
                print("🍳 Receita criada:")
                print(receitaCriada.id)
                
                let comentario = try service.criarComentario(
                    descricao: textoObservacao,
                    receita: receitaCriada
                )
                
                print("✅ Comentário criado:")
                print(comentario.id)
            }
            
            print("✅ Receita cadastrada com sucesso!")
            
            onSaved()
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
    
    func mostrarErro(
        _ mensagem: String
    ) {
        mensagemErro = mensagem
        mostrandoErro = true
    }
    
    private func converterDuracaoParaSegundos(
        _ duracao: String
    ) -> Int64? {
        
        let texto = duracao
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
        
        guard !texto.isEmpty else {
            return nil
        }
        
        var horas = 0
        var minutos = 0
        
        if let intervaloH = texto.range(of: "h") {
            
            let valorHoras = String(
                texto[..<intervaloH.lowerBound]
            )
            
            horas = Int(valorHoras) ?? 0
            
            let restante = String(
                texto[intervaloH.upperBound...]
            )
            
            if let intervaloMin = restante.range(of: "min") {
                
                let valorMinutos = String(
                    restante[..<intervaloMin.lowerBound]
                )
                
                minutos = Int(valorMinutos) ?? 0
            }
            
        } else if let intervaloMin = texto.range(of: "min") {
            
            let valorMinutos = String(
                texto[..<intervaloMin.lowerBound]
            )
            
            minutos = Int(valorMinutos) ?? 0
        }
        
        let totalSegundos =
            (horas * 60 * 60) +
            (minutos * 60)
        
        return totalSegundos > 0
            ? Int64(totalSegundos)
            : nil
    }
}

// MARK: - Erros

private enum ErroCadastro: Error {
    
    case ingredienteSemNome
    case quantidadeInvalida
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CadastrarReceita(
            service: PreviewSupport.receitaService
        )
    }
}
