//
//  CalculadoraReceitaView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 20/08/26.
//
import SwiftUI
struct CalculadoraReceitaView: View {
    
    let receita: ReceitaModel
    
    @State private var porcoesDesejadas = ""
    
    private var porcoes: Int? {
        Int(porcoesDesejadas)
    }
    
    private var fatorConversao: Double? {
        
        guard let porcoes,
              porcoes > 0,
              let porcoesOriginais = receita.porcoes,
              porcoesOriginais > 0 else {
            return nil
        }
        
        return Double(porcoes) / Double(porcoesOriginais)
    }
    
    var body: some View {
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                // MARK: - Porções atuais
                
                HStack {
                    Text("Porções atuais")
                    
                    Spacer()
                    
                    Text(
                        receita.porcoes.map(String.init)
                        ?? "Não informado"
                    )
                    .foregroundStyle(.secondary)
                }
                
                // MARK: - Porções desejadas
                
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    
                    Text("Número desejado de porções")
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold
                            )
                        )
                    
                    TextField(
                        "Ex.: 4",
                        text: $porcoesDesejadas
                    )
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .background(
                        Color.gray.opacity(0.10)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                }
                
                // MARK: - Ingredientes recalculados
                
                if let fatorConversao {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        
                        Text("Ingredientes")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .semibold
                                )
                            )
                        
                        ForEach(
                            receita.ingredientes
                        ) { ingrediente in
                            
                            IngredienteCalculadoRowView(
                                ingrediente: ingrediente,
                                fator: fatorConversao
                            )
                        }
                    }
                    
                } else {
                    
                    Text(
                        "Informe o número de porções desejadas para recalcular os ingredientes."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(20)
        }
        .fecharTecladoAoTocarFora()
        .navigationTitle("Calcular porções")
        .navigationBarTitleDisplayMode(.inline)
    }
}
