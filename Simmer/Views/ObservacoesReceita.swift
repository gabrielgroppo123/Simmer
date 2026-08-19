//
//  ObservacoesReceita.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 18/08/26.
//
import SwiftUI

struct ObservacoesReceita: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var pesquisa = ""
    @State private var mostrandoNovaObservacao = false
    @State private var novaObservacao = ""
    
    @State private var observacoes: [ObservacaoMock] = [
        
        ObservacaoMock(
            data: "02/08/2026",
            texto: "Fica excelente adicionando molho pesto de manjericão fresco no lugar do azeite tradicional. Se for preparar com antecedência, deixe para temperar na hora de servir para não murchar as folhas."
        ),
        
        ObservacaoMock(
            data: "18/04/2026",
            texto: "Substituí as nozes tradicionais por castanha-de-caju tostada e funcionou super bem. Adicionei também um toque de parmesão em lascas no final."
        ),
        
        ObservacaoMock(
            data: "23/01/2026",
            texto: "Rendimento perfeito para duas pessoas como acompanhamento. Para virar prato principal, vale a pena acrescentar tiras de frango grelhado ou queijo de cabra aquecido."
        ),
        
        ObservacaoMock(
            data: "17/10/2025",
            texto: "Secar bem as folhas com a centrífuga de salada antes do preparo faz toda a diferença para o molho fixar melhor e não diluir o sabor."
        )
    ]
    
    private var observacoesFiltradas: [ObservacaoMock] {
        
        if pesquisa.trimmingCharacters(
            in: .whitespacesAndNewlines).isEmpty {
            
            return observacoes
        }
        
        return observacoes.filter {
            $0.texto.localizedCaseInsensitiveContains(pesquisa)
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView {
                
                VStack(alignment: .leading,spacing: 0) {
                    
                    ForEach(observacoesFiltradas) { observacao in
                        
                        ObservacaoCardView(
                            observacao: observacao
                        )
                        .padding(.bottom, 36)
                    }
                    
                    Color.clear
                        .frame(height: 80)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
            .scrollIndicators(.hidden)
            
            barraPesquisa
        }
        .background(Color(.systemBackground))
        .navigationTitle("Observações")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(
                placement: .topBarTrailing) {
                Button {
                    novaObservacao = ""
                    mostrandoNovaObservacao = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .frame(
                            width: 44,
                            height: 44
                        )
                        .background(
                            Color.orange
                        )
                        .clipShape(Circle())
                }
                    
                .accessibilityLabel("Adicionar observação")
            }
        }
        
        .sheet(isPresented: $mostrandoNovaObservacao) {
            NovaObservacaoView(texto: $novaObservacao) {
                adicionarObservacao()
            }
        }
    }
}

// MARK: - Pesquisa

private extension ObservacoesReceita {
    
    var barraPesquisa: some View {
        
        HStack(spacing: 10) {
            
            Image(systemName: "magnifyingglass")
            .font(.system(size: 20))
            
            TextField("Pesquise sua receita",text: $pesquisa)
            
            if !pesquisa.isEmpty {
                
                Button {
                    pesquisa = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                }
            }
            
            Image(systemName: "mic.fill")
            .font(.system(size: 17)).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(.ultraThinMaterial).clipShape(Capsule())
        .overlay {
            Capsule().stroke(Color.gray.opacity(0.25),lineWidth: 1)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}

// MARK: - Ações

private extension ObservacoesReceita {
    
    func adicionarObservacao() {
        
        let texto = novaObservacao.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !texto.isEmpty else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let nova = ObservacaoMock(data: formatter.string(from: Date()),texto: texto)
        
        observacoes.insert(nova,at: 0)
        
        mostrandoNovaObservacao = false
        novaObservacao = ""
    }
}

// MARK: - Modelo temporário

private struct ObservacaoMock: Identifiable {
    
    let id = UUID()
    let data: String
    let texto: String
}

// MARK: - Card

private struct ObservacaoCardView: View {
    
    let observacao: ObservacaoMock
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 24) {
            
            Text(observacao.data)
            .font(.system(size: 21,weight: .bold))
            
            Text(observacao.texto)
            .font(.system(size: 20,weight: .regular))
            .fixedSize(horizontal: false,vertical: true)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(24)
        .background(Color.cardObservacoes)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22).stroke(Color(red: 1.0,green: 0.90,blue: 0.82),lineWidth: 1
            )
        }
    }
}

// MARK: - Nova observação

private struct NovaObservacaoView: View {
    
    @Binding var texto: String
    
    let adicionar: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                
                Text("Nova observação")
                .font(.system(size: 24,weight: .bold))
                
                TextEditor(text: $texto)
                .font(.system(size: 18))
                .padding(12)
                .scrollContentBackground(.hidden)
                .background(
                    Color(red: 1.0,green: 0.98,blue: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18).stroke(Color(red: 1.0,green: 0.90,blue: 0.82),lineWidth: 1)
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Observação")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(
                    placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                    
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button("Adicionar") {
                        adicionar()
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color(red: 1.0, green: 0.67,blue: 0.20))
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ObservacoesReceita()
    }
}
