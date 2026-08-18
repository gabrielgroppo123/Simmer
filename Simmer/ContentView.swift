//
//  ContentView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 13/08/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    private let service: ReceitaService
    
    init(service: ReceitaService) {
        self.service = service
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Simmer")
                .font(.largeTitle)
            
            Button("Testar CRUD") {
                testarCRUD()
            }
        }
        .padding()
    }
    
    private func testarCRUD() {
        
        // MARK: CREATE
        
        let ingredientes = [
            NovoIngrediente(
                nome: "Ovos",
                quantidade: 3,
                unidade: .unidades
            ),
            NovoIngrediente(
                nome: "Farinha de trigo",
                quantidade: 200,
                unidade: .gramas
            ),
            NovoIngrediente(
                nome: "Leite",
                quantidade: 200,
                unidade: .mililitros
            )
        ]
        
        let dados = NovaReceita(
            nome: "Bolo de Chocolate",
            categoria: .sobremesas,
            foto: imagemDeTeste(),
            porcoes: 8,
            duracao: 3600,
            utensilios: "Forma e batedeira",
            modoPreparo: "Misture todos os ingredientes e asse por 40 minutos.",
            ingredientes: ingredientes
        )
        
        do {
            
            let receita = try service.criarReceita(dados)
            
            print("✅ CREATE")
            print("Nome: \(receita.nome)")
            print("ID: \(receita.id)")
            
            // MARK: READ INGREDIENTES
            
            print("🥕 Ingredientes: \(receita.ingredientes.count)")
            
            for ingrediente in receita.ingredientes {
                print(
                    "• \(ingrediente.nome): " +
                    "\(ingrediente.quantidade) \(ingrediente.unidade)"
                )
            }
            
            // MARK: READ ONE
            
            guard let receitaEncontrada = try service.buscarReceita(
                id: receita.id
            ) else {
                print("❌ Receita não encontrada.")
                return
            }
            
            print("🔎 READ ONE")
            print("Nome: \(receitaEncontrada.nome)")
            
            // MARK: UPDATE
            
            try service.atualizarReceita(
                receitaEncontrada,
                nome: "Bolo de Chocolate Especial",
                categoria: receitaEncontrada.categoria,
                foto: receitaEncontrada.foto,
                porcoes: 12,
                duracao: receitaEncontrada.duracao,
                utensilios: receitaEncontrada.utensilios,
                modoPreparo: receitaEncontrada.modoPreparo,
                ingredientes: receitaEncontrada.ingredientes.map {
                    NovoIngrediente(
                        nome: $0.nome,
                        quantidade: $0.quantidade,
                        unidade: $0.unidade
                    )
                }
            )
            
            print("✏️ UPDATE")
            
            // Como o método de update não devolve a receita,
            // buscamos novamente para confirmar a alteração.
            
            guard let receitaAtualizada = try service.buscarReceita(
                id: receita.id
            ) else {
                print("❌ Receita não encontrada após UPDATE.")
                return
            }
            
            print("Nome depois do UPDATE: \(receitaAtualizada.nome)")
            print("Porções depois do UPDATE: \(receitaAtualizada.porcoes)")
            
            // MARK: DELETE
            
            try service.deletarReceita(receitaAtualizada)
            
            print("🗑️ DELETE")
            
            // Confirma que realmente foi excluída.
            
            let receitaDepoisDoDelete = try service.buscarReceita(
                id: receita.id
            )
            
            if receitaDepoisDoDelete == nil {
                print("✅ Receita não encontrada após DELETE!")
            } else {
                print("❌ A receita ainda existe!")
            }
            
        } catch {
            print("❌ Erro: \(error)")
        }
    }
    
    private func imagemDeTeste() -> Data {
        let imagem = UIImage(
            systemName: "fork.knife.circle.fill"
        )!
        
        return imagem.pngData()!
    }
}

#Preview {
    ContentView(
        service: PreviewSupport.receitaService
    )
}
