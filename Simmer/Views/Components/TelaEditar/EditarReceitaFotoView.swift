//
//  EditarReceitaFotoView.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 18/08/26.
//
import SwiftUI
import PhotosUI
import UIKit

struct EditarReceitaFotoView: View {

    @Binding var foto: Data
    @Binding var fotoSelecionada: PhotosPickerItem?

    var body: some View {

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
}
