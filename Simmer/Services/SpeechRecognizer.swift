//
//  SpeechRecognizer.swift
//  Simmer
//
//  Created by Gabriel Groppo on 14/08/26.
//

import Speech
import AVFoundation
import Combine

final class SpeechRecognizer: ObservableObject {
    
    @Published var textoReconhecido = ""
    @Published var estaOuvindo = false
    
    private let audioEngine = AVAudioEngine()
    
    private let speechRecognizer = SFSpeechRecognizer(
        locale: Locale(identifier: "pt-BR")
    )
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    func solicitarPermissao() async -> Bool {
        
        let autorizacaoSpeech = await withCheckedContinuation { continuation in
            
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(
                    returning: status == .authorized
                )
            }
        }
        
        guard autorizacaoSpeech else {
            return false
        }
        
        let autorizacaoMicrofone = await AVAudioApplication.requestRecordPermission()
        
        return autorizacaoMicrofone
    }
    
    func iniciarReconhecimento() {
        
        // Cancela uma tarefa anterior, caso exista.
        recognitionTask?.cancel()
        recognitionTask = nil
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let request = request else {
            return
        }
        
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: .duckOthers
            )
            
            try audioSession.setActive(
                true,
                options: .notifyOthersOnDeactivation
            )
            
        } catch {
            print("❌ Erro ao configurar áudio: \(error)")
            return
        }
        
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(
            forBus: 0
        )
        
        inputNode.removeTap(
            onBus: 0
        )
        
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { [weak self] buffer, _ in
            
            request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            
            DispatchQueue.main.async {
                self.estaOuvindo = true
                self.textoReconhecido = ""
            }
            
        } catch {
            print("❌ Erro ao iniciar microfone: \(error)")
            return
        }
        
        recognitionTask = speechRecognizer.recognitionTask(
            with: request
        ) { [weak self] resultado, error in
            
            guard let self = self else {
                return
            }
            
            if let resultado = resultado {
                
                DispatchQueue.main.async {
                    self.textoReconhecido =
                        resultado.bestTranscription.formattedString
                }
            }
            
            if error != nil || resultado?.isFinal == true {
                self.pararReconhecimento()
            }
        }
    }
    
    func pararReconhecimento() {
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        request?.endAudio()
        recognitionTask?.cancel()
        
        request = nil
        recognitionTask = nil
        
        DispatchQueue.main.async {
            self.estaOuvindo = false
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(
                false,
                options: .notifyOthersOnDeactivation
            )
        } catch {
            print("❌ Erro ao desativar áudio: \(error)")
        }
    }
}
