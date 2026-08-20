//
//  CardDetalhesView.swift
//  Simmer
//
//  Created by Rebeca Emanuela Calmon de Andrade Alves on 20/08/26.
//
import SwiftUI

struct CardDetalhesView<Content: View>: View {
    var paddingVertical: CGFloat
    var paddingHorizontal: CGFloat
    let content: Content

    init(
        paddingVertical: CGFloat = 16,
        paddingHorizontal: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.paddingVertical = paddingVertical
        self.paddingHorizontal = paddingHorizontal
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("CardObservacoes")) // Tom de laranja super suave e translúcido
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("TracadoCardObs"), lineWidth: 1)
            )
    }
}
