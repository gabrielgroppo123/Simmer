//
//  ReceitaTempoView.swift
//  Simmer
//
//  Created by Gabriel Groppo on 18/08/26.
//

import SwiftUI

struct ReceitaTempoView: View {
    
    @Binding var duracao: String
    
    var body: some View {
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
            .clipShape(Capsule())
        }
    }
}
