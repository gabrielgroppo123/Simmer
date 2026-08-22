//
//  CameraView.swift
//  Simmer
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    
    let resultado: (UIImage?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            resultado: resultado
        )
    }
    
    func makeUIViewController(
        context: Context
    ) -> UIImagePickerController {
        
        let picker =
            UIImagePickerController()
        
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(
        _ uiViewController:
            UIImagePickerController,
        context: Context
    ) {}
    
    final class Coordinator:
        NSObject,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate {
        
        let resultado: (UIImage?) -> Void
        
        init(
            resultado:
                @escaping (UIImage?) -> Void
        ) {
            self.resultado = resultado
        }
        
        // MARK: - Foto capturada
        
        func imagePickerController(
            _ picker:
                UIImagePickerController,
            didFinishPickingMediaWithInfo info:
                [
                    UIImagePickerController.InfoKey:
                    Any
                ]
        ) {
            
            guard let imagem =
                    info[
                        .originalImage
                    ] as? UIImage
            else {
                return
            }
            
            mostrarConfirmacao(
                no: picker,
                imagem: imagem
            )
        }
        
        // MARK: - Confirmação
        
        private func mostrarConfirmacao(
            no picker:
                UIImagePickerController,
            imagem: UIImage
        ) {
            
            let alert = UIAlertController(
                title: "Usar esta foto?",
                message:
                    "Esta imagem será adicionada à receita.",
                preferredStyle: .alert
            )
            
            // Cancelar
            alert.addAction(
                UIAlertAction(
                    title: "Cancelar",
                    style: .cancel
                )
            )
            
            // Confirmar
            alert.addAction(
                UIAlertAction(
                    title: "Confirmar",
                    style: .default
                ) { [weak self] _ in
                    
                    self?.resultado(imagem)
                }
            )
            
            picker.present(
                alert,
                animated: true
            )
        }
        
        // MARK: - Cancelar câmera
        
        func imagePickerControllerDidCancel(
            _ picker:
                UIImagePickerController
        ) {
            
            resultado(nil)
        }
    }
}
