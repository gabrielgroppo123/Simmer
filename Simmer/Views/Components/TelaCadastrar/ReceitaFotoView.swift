//
//  ReceitaFotoView.swift
//  Simmer
//

import SwiftUI
import PhotosUI
import UIKit

struct ReceitaFotoView: View {
    
    @Binding var foto: Data?
    @Binding var fotoSelecionada: PhotosPickerItem?
    
    @State private var mostrandoMenuFoto = false
    @State private var mostrandoCamera = false
    @State private var mostrandoGaleria = false
    
    @State private var imagemTemporaria: UIImage?
    @State private var mostrandoConfirmacaoGaleria = false
    
    var body: some View {
        
        Button {
            mostrandoMenuFoto = true
        } label: {
            
            ZStack {
                
                RoundedRectangle(
                    cornerRadius: 16
                )
                .fill(
                    Color.gray.opacity(0.14)
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
                        .font(
                            .system(size: 42)
                        )
                        .foregroundStyle(
                            .gray.opacity(0.55)
                        )
                        
                        Text(
                            "Adicione uma imagem"
                        )
                        .font(
                            .system(size: 17)
                        )
                        .foregroundStyle(
                            .gray.opacity(0.65)
                        )
                    }
                }
            }
            .frame(
                width: 224,
                height: 180
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            foto == nil
                ? "Adicionar imagem"
                : "Alterar imagem"
        )
        
        // MARK: - Menu de opções
        
        .confirmationDialog(
            "Adicionar imagem",
            isPresented: $mostrandoMenuFoto,
            titleVisibility: .visible
        ) {
            
            Button {
                mostrandoCamera = true
            } label: {
                Label(
                    "Tirar foto",
                    systemImage: "camera"
                )
            }
            
            Button {
                mostrandoGaleria = true
            } label: {
                Label(
                    "Escolher foto",
                    systemImage: "photo.on.rectangle"
                )
            }
            
            Button(
                "Cancelar",
                role: .cancel
            ) {}
        }
        
        // MARK: - Câmera
        
        .fullScreenCover(
            isPresented: $mostrandoCamera
        ) {
            
            CameraView { imagem in
                
                if let imagem {
                    foto = imagem.jpegData(
                        compressionQuality: 0.8
                    )
                }
                
                mostrandoCamera = false
            }
        }
        
        // MARK: - Galeria
        
        .photosPicker(
            isPresented: $mostrandoGaleria,
            selection: $fotoSelecionada,
            matching: .images
        )
        
        // MARK: - Imagem selecionada da galeria
        
        .onChange(
            of: fotoSelecionada
        ) { _, novoItem in
            
            carregarImagemDaGaleria(
                novoItem
            )
        }
        
        // MARK: - Confirmação da galeria
        
        .alert(
            "Usar esta foto?",
            isPresented:
                $mostrandoConfirmacaoGaleria
        ) {
            
            Button("Cancelar", role: .cancel) {
                
                imagemTemporaria = nil
                fotoSelecionada = nil
                
                // Abre a galeria novamente
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.3
                ) {
                    mostrandoGaleria = true
                }
            }
            
            Button("Confirmar") {
                confirmarFotoDaGaleria()
            }
            
        } message: {
            
            Text(
                "Esta imagem será adicionada à receita."
            )
        }
    }
    
    // MARK: - Galeria
    
    private func carregarImagemDaGaleria(
        _ item: PhotosPickerItem?
    ) {
        
        guard let item else {
            return
        }
        
        Task {
            
            do {
                
                guard let data =
                        try await item.loadTransferable(
                            type: Data.self
                        ),
                      let imagem = UIImage(
                        data: data
                      )
                else {
                    return
                }
                
                await MainActor.run {
                    
                    imagemTemporaria = imagem
                    
                    mostrandoConfirmacaoGaleria = true
                }
                
            } catch {
                
                print(
                    "❌ Erro ao carregar imagem: \(error)"
                )
            }
        }
    }
    
    // MARK: - Confirmar galeria
    
    private func confirmarFotoDaGaleria() {
        
        guard let imagemTemporaria,
              let data = imagemTemporaria.jpegData(
                compressionQuality: 0.8
              )
        else {
            return
        }
        
        foto = data
        
        self.imagemTemporaria = nil
        fotoSelecionada = nil
    }
}
