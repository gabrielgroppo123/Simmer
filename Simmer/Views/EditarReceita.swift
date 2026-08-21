//
//  EditarReceita.swift
//  Simmer
//

import SwiftUI
import PhotosUI
import UIKit

struct EditarReceita: View {
    
    // MARK: - Propriedades
    
    let receita: ReceitaModel
    private let service: ReceitaService
    private let onSaved: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var nome: String
    @State private var categoria: Categoria?
    @State private var foto: Data?
    @State private var porcoes: String
    @State private var duracao: String
    @State private var utensilios: [String]
    @State private var modoPreparo: String
    @State private var observacao: String
    
    @State private var ingredientes: [IngredienteFormulario]
    
    @State private var fotoSelecionada: PhotosPickerItem?
    @State private var mostrandoErro = false
    @State private var mensagemErro = ""
    
    // MARK: - Inicializador
    
    init(
        receita: ReceitaModel,
        service: ReceitaService,
        onSaved: @escaping () -> Void = {}
    ) {
        self.receita = receita
        self.service = service
        self.onSaved = onSaved
        
        _nome = State(initialValue: receita.nome)
        _categoria = State(initialValue: receita.categoria)
        _foto = State(initialValue: receita.foto)
        
        _porcoes = State(
            initialValue: receita.porcoes.map(String.init) ?? ""
        )
        
        // Converte a duração salva (segundos) em formato de texto
        let totalMinutos = receita.duracao / 60
        let h = totalMinutos / 60
        let m = totalMinutos % 60
        let textoDuracao = h > 0 ? (m > 0 ? "\(h)h \(m)min" : "\(h)h") : "\(m)min"
        _duracao = State(initialValue: textoDuracao)
        
        // Separa a string de utensílios salvos em array
        let listaUtensilios = receita.utensilios?
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty } ?? []
        _utensilios = State(initialValue: listaUtensilios)
        
        _modoPreparo = State(
            initialValue: receita.modoPreparo
        )
        
        _observacao = State(
            initialValue: receita.comentarios.first?.descricao ?? ""
        )
        
        let ingredientesIniciais = receita.ingredientes.map {
            IngredienteFormulario(
                id: $0.id,
                nome: $0.nome,
                quantidade: $0.quantidade.truncatingRemainder(dividingBy: 1) == 0 ? String(Int($0.quantidade)) : String($0.quantidade),
                unidade: $0.unidade
            )
        }
        
        _ingredientes = State(
            initialValue: ingredientesIniciais
        )
    }
    
    // MARK: - Body
    
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
        .scrollIndicators(.hidden)
        .background(
            Color(.systemBackground)
        )
        .navigationTitle("Editar receita")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    salvarAlteracoes()
                } label: {
                    Image(systemName: "checkmark")
                }
                .accessibilityLabel("Salvar alterações")
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
    
    // MARK: - Métodos Auxiliares
    
    private func carregarFoto() async {
        guard let fotoSelecionada else { return }
        
        do {
            if let novaFoto = try await fotoSelecionada.loadTransferable(type: Data.self) {
                foto = novaFoto
            }
        } catch {
            print("❌ Erro ao carregar foto: \(error)")
        }
    }
    
    private func salvarAlteracoes() {
        guard !nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            mostrarErro("Informe o nome da receita.")
            return
        }
        
        guard let foto, !foto.isEmpty else {
            mostrarErro("A foto da receita é obrigatória.")
            return
        }
        
        guard let porcoesInt = Int16(porcoes), porcoesInt > 0 else {
            mostrarErro("Informe uma quantidade válida de porções.")
            return
        }
        
        guard let duracaoInt = converterDuracaoParaSegundos(duracao), duracaoInt > 0 else {
            mostrarErro("Informe um tempo de preparo válido.")
            return
        }
        
        guard !modoPreparo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            mostrarErro("Informe o modo de preparo.")
            return
        }
        
        guard !ingredientes.isEmpty else {
            mostrarErro("Adicione pelo menos um ingrediente.")
            return
        }
        
        let novosIngredientes: [NovoIngrediente]
        do {
            novosIngredientes = try ingredientes.map {
                guard !$0.nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    throw ErroEdicao.ingredienteSemNome
                }
                
                guard let quantidade = Double($0.quantidade.replacingOccurrences(of: ",", with: ".")),
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
            mostrarErro("Verifique os dados dos ingredientes.")
            return
        }
        
        let utensiliosString = utensilios
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
        
        guard let categoria else {
            mostrarErro("Escolha uma categoria para a receita.")
            return
        }
        
        do {
            try service.atualizarReceita(
                receita,
                nome: nome,
                categoria: categoria,
                foto: foto,
                porcoes: porcoesInt,
                duracao: duracaoInt,
                utensilios: utensiliosString.isEmpty ? nil : utensiliosString,
                modoPreparo: modoPreparo,
                ingredientes: novosIngredientes
            )
            
            print("✅ Receita atualizada com sucesso!")
            
            // Dispara o callback para atualizar a tela anterior
            onSaved()
            
            dismiss()
            
        } catch {
            mostrarErro("Ocorreu um erro ao atualizar a receita.")
            print("❌ Erro ao atualizar receita: \(error)")
        }
    }
    
    private func mostrarErro(_ mensagem: String) {
        mensagemErro = mensagem
        mostrandoErro = true
    }
    
    private func converterDuracaoParaSegundos(_ duracao: String) -> Int64? {
        let texto = duracao.lowercased().replacingOccurrences(of: " ", with: "")
        guard !texto.isEmpty else { return nil }
        
        var horas = 0
        var minutos = 0
        
        if let intervaloH = texto.range(of: "h") {
            let valorHoras = String(texto[..<intervaloH.lowerBound])
            horas = Int(valorHoras) ?? 0
            
            let restante = String(texto[intervaloH.upperBound...])
            if let intervaloMin = restante.range(of: "min") {
                let valorMinutos = String(restante[..<intervaloMin.lowerBound])
                minutos = Int(valorMinutos) ?? 0
            }
        } else if let intervaloMin = texto.range(of: "min") {
            let valorMinutos = String(texto[..<intervaloMin.lowerBound])
            minutos = Int(valorMinutos) ?? 0
        }
        
        let totalSegundos = (horas * 60 * 60) + (minutos * 60)
        return totalSegundos > 0 ? Int64(totalSegundos) : nil
    }
}

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
                categoria: .doces,
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
