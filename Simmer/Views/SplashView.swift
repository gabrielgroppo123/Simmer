//
//  SplashView.swift
//  Simmer
//
//  Created by Mariana Fracaroli Lopes on 19/08/26.
//

import SwiftUI
import AVKit

struct SplashView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let onFinish: () -> Void
    
    private var nomeDoVideo: String {
        colorScheme == .dark
            ? "SplashDark 2"
            : "SplashLight 2"
    }
    
    var body: some View {
        SplashVideoView(
            nomeDoVideo: nomeDoVideo,
            onFinish: onFinish
        )
        .ignoresSafeArea()
    }
}

private struct SplashVideoView: UIViewRepresentable {
    
    let nomeDoVideo: String
    let onFinish: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            onFinish: onFinish
        )
    }
    
    func makeUIView(
        context: Context
    ) -> UIView {
        
        let view = UIView()
        
        guard let url = Bundle.main.url(
            forResource: nomeDoVideo,
            withExtension: "mp4"
        ) else {
            return view
        }
        
        let player = AVPlayer(
            url: url
        )
        
        context.coordinator.player = player
        
        let playerLayer = AVPlayerLayer(
            player: player
        )
        
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        
        view.layer.addSublayer(
            playerLayer
        )
        
        context.coordinator.observarFimDoVideo(
            player: player
        )
        
        player.play()
        
        return view
    }
    
    func updateUIView(
        _ uiView: UIView,
        context: Context
    ) {
    }
    
    final class Coordinator {
        
        var player: AVPlayer?
        
        private let onFinish: () -> Void
        private var observer: NSObjectProtocol?
        
        init(
            onFinish: @escaping () -> Void
        ) {
            self.onFinish = onFinish
        }
        
        func observarFimDoVideo(
            player: AVPlayer
        ) {
            
            observer = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { [weak self] _ in
                
                self?.onFinish()
            }
        }
        
        deinit {
            
            if let observer {
                NotificationCenter.default.removeObserver(
                    observer
                )
            }
        }
    }
}

#Preview {
    SplashView(
        onFinish: {}
    )
}
