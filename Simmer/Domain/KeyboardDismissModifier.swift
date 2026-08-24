//
//  Key.swift
//  Simmer
//
//  Created by Gabriel Groppo on 22/08/26.
//

import SwiftUI
import UIKit

extension View {
    
    func fecharTecladoAoTocarFora() -> some View {
        self.simultaneousGesture(
            TapGesture()
                .onEnded {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
        )
    }
}
