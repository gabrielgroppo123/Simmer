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
    
    // MARK: - Permissões
    
    func solicitarPermissao() async -> Bool {
        
        let autorizacaoSpeech =
            await withCheckedContinuation { continuation in
                
                SFSpeechRecognizer.requestAuthorization { status in
                    
                    continuation.resume(
                        returning: status == .authorized
                    )
                }
            }
        
        guard autorizacaoSpeech else {
            return false
        }
        
        let autorizacaoMicrofone =
            await AVAudioApplication.requestRecordPermission()
        
        return autorizacaoMicrofone
    }
    
    // MARK: - Iniciar reconhecimento
    
    func iniciarReconhecimento() {
        
        // Cancela reconhecimento anterior
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Garante que não exista um tap anterior
        let inputNode = audioEngine.inputNode
        
        inputNode.removeTap(onBus: 0)
        
        // Cria nova requisição
        let novaRequest =
            SFSpeechAudioBufferRecognitionRequest()
        
        request = novaRequest
        
        novaRequest.shouldReportPartialResults = true
        
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            
            print("❌ Reconhecimento de fala indisponível.")
            return
        }
        
        // MARK: - Configuração do áudio
        
        let audioSession =
            AVAudioSession.sharedInstance()
        
        do {
            
            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: [.duckOthers]
            )
            
            try audioSession.setActive(
                true,
                options: .notifyOthersOnDeactivation
            )
            
        } catch {
            
            print(
                "❌ Erro ao configurar sessão de áudio: \(error)"
            )
            
            return
        }
        
        // MARK: - Verificar microfone
        
        let recordingFormat =
            inputNode.outputFormat(forBus: 0)
        
        guard recordingFormat.sampleRate > 0,
              recordingFormat.channelCount > 0 else {
            
            print(
                "❌ Microfone indisponível ou formato de áudio inválido."
            )
            
            return
        }
        
        // MARK: - Capturar áudio
        
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { [weak self] buffer, _ in
            
            self?.request?.append(buffer)
        }
        
        // MARK: - Preparar AudioEngine
        
        audioEngine.prepare()
        
        do {
            
            try audioEngine.start()
            
            DispatchQueue.main.async {
                self.estaOuvindo = true
                self.textoReconhecido = ""
            }
            
        } catch {
            
            print(
                "❌ Erro ao iniciar AudioEngine: \(error)"
            )
            
            inputNode.removeTap(onBus: 0)
            
            return
        }
        
        // MARK: - Reconhecimento
        
        recognitionTask =
            speechRecognizer.recognitionTask(
                with: novaRequest
            ) { [weak self] resultado, error in
                
                guard let self else {
                    return
                }
                
                if let resultado {
                    
                    DispatchQueue.main.async {
                        
                        self.textoReconhecido =
                            resultado.bestTranscription
                            .formattedString
                    }
                }
                
                if error != nil ||
                    resultado?.isFinal == true {
                    
                    self.pararReconhecimento()
                }
            }
    }
    
    // MARK: - Parar reconhecimento
    
    func pararReconhecimento() {
        
        audioEngine.stop()
        
        audioEngine.inputNode.removeTap(
            onBus: 0
        )
        
        request?.endAudio()
        
        recognitionTask?.cancel()
        
        request = nil
        recognitionTask = nil
        
        DispatchQueue.main.async {
            self.estaOuvindo = false
        }
        
        do {
            
            try AVAudioSession.sharedInstance()
                .setActive(
                    false,
                    options: .notifyOthersOnDeactivation
                )
            
        } catch {
            
            print(
                "❌ Erro ao desativar áudio: \(error)"
            )
        }
    }
}
