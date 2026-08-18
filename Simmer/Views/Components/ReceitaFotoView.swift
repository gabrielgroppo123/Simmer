//
//  ReceitaFotoView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI
import PhotosUI
import UIKit

struct ReceitaFotoView: View {
    
    @Binding var foto: Data?
    @Binding var fotoSelecionada: PhotosPickerItem?
    
    var body: some View {
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
                        
                        Image(systemName: "photo")
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
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
        .accessibilityLabel(
            foto == nil
                ? "Adicionar imagem"
                : "Alterar imagem"
        )
    }
}
