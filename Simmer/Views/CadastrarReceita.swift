//
//  CadastrarReceita.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//

import SwiftUI
import PhotosUI
import UIKit

struct CadastrarReceita: View {
    
    private let service: ReceitaService
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var nome = ""
    @State private var categoria: Categoria = .outro
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
    
    init(service: ReceitaService) {
        self.service = service
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: - Foto
                
                fotoView
                    .padding(.top, 18)
                
                // MARK: - Nome
                
                campoNome
                    .padding(.top, 46)
                
                // MARK: - Informações
                
                tempoPreparo
                    .padding(.top, 34)
                
                seletorPorcoes
                    .padding(.top, 26)
                
                seletorCategoria
                    .padding(.top, 22)
                
                // MARK: - Ingredientes
                
                secaoIngredientes
                    .padding(.top, 48)
                
                // MARK: - Modo de preparo
                
                secaoModoPreparo
                    .padding(.top, 48)
                
                // MARK: - Utensílios
                
                secaoUtensilios
                    .padding(.top, 46)
                
                // MARK: - Observações
                
                secaoObservacoes
                    .padding(.top, 46)
                
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemBackground))
        .navigationTitle("Nova Receita")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    salvarReceita()
                } label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.medium)
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
}

// MARK: - Componentes da tela

private extension CadastrarReceita {
    
    // MARK: Foto
    
    var fotoView: some View {
        PhotosPicker(
            selection: $fotoSelecionada,
            matching: .images
        ) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        Color.gray.opacity(0.14)
                    )
                    .frame(
                        width: 224,
                        height: 180
                    )
                
                if let foto,
                   let imagem = UIImage(data: foto) {
                    
                    Image(uiImage: imagem)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: 224,
                            height: 180
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 16
                            )
                        )
                    
                } else {
                    
                    VStack(spacing: 14) {
                        
                        Image(
                            systemName: "photo"
                        )
                        .font(.system(size: 42))
                        .foregroundStyle(
                            .gray.opacity(0.55)
                        )
                        
                        Text("Adicione uma imagem")
                            .font(.system(size: 17))
                            .foregroundStyle(
                                .gray.opacity(0.65)
                            )
                    }
                }
            }
        }
        .frame(
            maxWidth: .infinity
        )
        .buttonStyle(.plain)
        .accessibilityLabel(
            foto == nil
                ? "Adicionar imagem"
                : "Alterar imagem"
        )
    }
    
    // MARK: Nome
    
    var campoNome: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            HStack(alignment: .firstTextBaseline) {
                
                Text("Nome da Receita")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )
                
                Text("*")
                    .foregroundStyle(.red)
                
                Spacer()
                
                if nome.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty {
                    Text("campo obrigatório")
                        .font(.system(size: 12))
                        .foregroundStyle(.red.opacity(0.75))
                }
            }
            
            TextField(
                "Ex: Pudim",
                text: $nome
            )
            .font(.system(size: 18))
            .textInputAutocapitalization(.sentences)
            
            Divider()
        }
    }
    
    // MARK: Tempo
    
    var tempoPreparo: some View {
        HStack {
            
            Image(systemName: "clock")
                .font(.system(size: 20))
                .frame(width: 28)
            
            Text("Tempo de preparo")
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
            
            Spacer()
            
            TextField(
                "0",
                text: $duracao
            )
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.system(size: 16))
            .frame(
                width: 62,
                height: 36
            )
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                Capsule()
            )
        }
    }
    
    // MARK: Porções
    
    var seletorPorcoes: some View {
        HStack {
            
            Image(systemName: "person.2")
                .font(.system(size: 19))
                .frame(width: 28)
            
            Text("Porções")
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
            
            Spacer()
            
            HStack(spacing: 0) {
                
                Button {
                    diminuirPorcoes()
                } label: {
                    Image(systemName: "minus")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .frame(
                            width: 38,
                            height: 38
                        )
                }
                
                Text(
                    porcoes.isEmpty
                        ? "0"
                        : porcoes
                )
                .font(.system(size: 17))
                .frame(
                    width: 34
                )
                
                Button {
                    aumentarPorcoes()
                } label: {
                    Image(systemName: "plus")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .frame(
                            width: 38,
                            height: 38
                        )
                }
            }
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                Capsule()
            )
        }
    }
    
    // MARK: Categoria
    
    var seletorCategoria: some View {
        HStack {
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 19))
                .frame(width: 28)
            
            Text("Categoria")
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
            
            Spacer()
            
            Menu {
                
                ForEach(
                    Categoria.allCases
                ) { categoria in
                    
                    Button {
                        self.categoria = categoria
                    } label: {
                        Text(categoria.rawValue)
                    }
                }
                
            } label: {
                
                HStack(spacing: 7) {
                    
                    Text(
                        categoria == .outro
                            ? "Escolher"
                            : categoria.rawValue
                    )
                    .font(.system(size: 15))
                    .foregroundStyle(
                        categoria == .outro
                            ? .secondary
                            : .primary
                    )
                    
                    Image(
                        systemName: "chevron.up.chevron.down"
                    )
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(
                    Color.gray.opacity(0.10)
                )
                .clipShape(
                    Capsule()
                )
            }
        }
    }
    
    // MARK: Ingredientes
    
    var secaoIngredientes: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(alignment: .firstTextBaseline) {
                
                Text("Ingredientes")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                
                Text("*")
                    .foregroundStyle(.red)
                
                Spacer()
                
                if ingredientes.isEmpty {
                    Text("campo obrigatório")
                        .font(.system(size: 12))
                        .foregroundStyle(
                            .red.opacity(0.75)
                        )
                }
            }
            
            // Cabeçalho
            
            HStack(spacing: 12) {
                
                Text("Nome do ingrediente")
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                
                Text("Qtd")
                    .frame(
                        width: 48,
                        alignment: .leading
                    )
                
                Text("Unidade")
                    .frame(
                        width: 78,
                        alignment: .leading
                    )
            }
            .font(.system(size: 14))
            
            // Ingredientes
            
            ForEach(
                $ingredientes
            ) { $ingrediente in
                
                HStack(
                    alignment: .top,
                    spacing: 12
                ) {
                    
                    TextField(
                        "Ex: Leite",
                        text: $ingrediente.nome
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    
                    TextField(
                        "250",
                        text: $ingrediente.quantidade
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 48)
                    
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
                    .labelsHidden()
                    .frame(width: 78)
                }
                .font(.system(size: 16))
                
                Divider()
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
                    systemImage: "plus.circle"
                )
                .font(.system(size: 15))
            }
        }
    }
    
    // MARK: Modo de preparo
    
    var secaoModoPreparo: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .firstTextBaseline) {
                
                Text("Modo de Fazer")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                
                Text("*")
                    .foregroundStyle(.red)
                
                Spacer()
                
                if modoPreparo.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty {
                    Text("campo obrigatório")
                        .font(.system(size: 12))
                        .foregroundStyle(
                            .red.opacity(0.75)
                        )
                }
            }
            
            TextField(
                "Ex: Refogue no azeite a cebola, o alho, o tomate e o pimentão...",
                text: $modoPreparo,
                axis: .vertical
            )
            .font(.system(size: 17))
            .lineLimit(5...8)
            
            Divider()
        }
    }
    
    // MARK: Utensílios
    
    var secaoUtensilios: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Utensílios")
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )
            
            ForEach(
                utensilios.indices,
                id: \.self
            ) { indice in
                
                HStack(spacing: 8) {
                    
                    TextField(
                        "Adicionar utensílio",
                        text: $utensilios[indice]
                    )
                    .font(.system(size: 17))
                    
                    Button {
                        removerUtensilio(
                            no: indice
                        )
                    } label: {
                        Image(
                            systemName: "minus.circle"
                        )
                        .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
            }
            
            Button {
                adicionarUtensilio()
            } label: {
                Label(
                    "Adicionar utensílio",
                    systemImage: "plus.circle"
                )
                .font(.system(size: 15))
            }
        }
    }
    
    // MARK: Observações
    
    var secaoObservacoes: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                
                Text("Observações")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                
                Spacer()
                
                Button {
                    // O campo já fica disponível.
                    // Esse botão será conectado ao fluxo
                    // de comentários posteriormente.
                } label: {
                    Image(systemName: "plus")
                        .font(
                            .system(
                                size: 20,
                                weight: .medium
                            )
                        )
                        .frame(
                            width: 48,
                            height: 48
                        )
                        .background(
                            Color.gray.opacity(0.08)
                        )
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            
            TextField(
                "Sinta-se livre para adicionar seus pensamentos sobre a receita.",
                text: $observacao,
                axis: .vertical
            )
            .font(.system(size: 15))
            .lineLimit(3...7)
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
        
        guard let duracaoInt = Int64(duracao),
              duracaoInt > 0 else {
            
            mostrarErro(
                "Informe uma duração válida."
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
        
        let dados = NovaReceita(
            nome: nome,
            categoria: categoria,
            foto: foto,
            porcoes: porcoesInt,
            duracao: duracaoInt * 60,
            utensilios: utensiliosString.isEmpty
                ? nil
                : utensiliosString,
            modoPreparo: modoPreparo,
            ingredientes: novosIngredientes
        )
        
        do {
            
            _ = try service.criarReceita(
                dados
            )
            
            print(
                "✅ Receita cadastrada com sucesso!"
            )
            
            if !observacao.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty {
                
                print(
                    "📝 Observação preenchida: \(observacao)"
                )
            }
            
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
}

// MARK: - Modelo temporário

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

// MARK: - Preview

#Preview {
    NavigationStack {
        CadastrarReceita(
            service: PreviewSupport.receitaService
        )
    }
}
