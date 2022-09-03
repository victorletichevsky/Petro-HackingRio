//
//  SpeechRecognizerViewModel.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import Foundation
import AVFoundation
import Foundation
import Speech
import SwiftUI

class SpeechRecognizerViewModel: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    @Published var transcript: String = ""
    
    @Published var isHearing: Bool
    @Published var count = 0
    @Published var searchUser: String = ""
    @Published var users: [User] = [User.init(name: "Victor Letichevsky", competencies: "Computação", profileImage: "FotoVictorLetichevsky", password: "1234"), User(name: "Bernardo Delgado", competencies: "Engenharia", profileImage: "", password: "1234")]
    @Published var documents: [Document] = [Document.init(titulo: "Geração de energia elétrica a partir de borras oleosas", autor:"UNIVERSIDADE FEDERAL DE ITAJUBÁ/UNIFEI", descricao: "A utilização de resíduos para a geração de energia elétrica é uma forma de aumentar a disponibilidade de insumos energéticos aliada à redução de passivos ambientais. A indústria do petróleo gera consideráveis quantidades de borra oleosa com PCI entre 15 e 20MJ/kg. Estas borras podem ser utilizadas como insumo energético para geração termelétrica por meio da geração de gás de síntese (GS) através do processo de gaseificação. Para isto, faz-se necessária a seleção adequada das tecnologias de pré-tratamento, gaseificação e do arranjo termelétrico mais propício. A destinação do resíduo para a geração de energia elétrica traz benefícios econômicos e ambientais adicionais, já que esse resíduo, considerado perigoso, possui grande custo de disposição, podendo representar riscos ao meio ambiente."), Document(titulo: "Energia elétrica de biomassa lignocelulósica", autor:"FUTURA ENERGIA SERVICOS LTDA; UNIVERSIDADE FEDERAL DO RIO DE JANEIRO/UFRJ" ,descricao: "Oportunidade de geração de energia elétrica e biogás (biometano)a partir de biomassa lignocelulósica."), Document(titulo: "Novos sistemas fotovoltaicos", autor: "Projeto Interno", descricao: "O setor fotovoltaico encontra-se hoje dominado pela tecnologia de silício cristalino onde o produto, o módulo fotovoltaico, apresenta um comportamento muito semelhante a uma commodity. Essa tecnologia apresenta características intrínsecas, decorrentes da sua própria concepção, que a descredenciam para o crescimento da produção.")]
    
    var searchResultUser: [User] {
        if searchUser.isEmpty {
            return users
        } else {
            return users.filter { $0.competencies.localizedStandardContains(searchUser) || $0.name.localizedStandardContains(searchUser) }
        }
    }
    var searchResultDocument: [Document] {
        if searchUser.isEmpty {
            return documents
        } else {
            return documents.filter { $0.titulo.localizedStandardContains(searchUser) || $0.autor.localizedStandardContains(searchUser) || $0.descricao.localizedStandardContains(searchUser) }
        }
    }
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    private var lastWordHeared:String = ""
    private var wordsToSearch:[String] = []
    
    init() {
        self.isHearing = false
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
        
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
        }
    }
    func verifySearch() -> Bool {
        if searchUser.isEmpty {
            return false
        } else {
            return true
        }
    }
    deinit {
        reset()
    }
    
    func transcribe() {
        DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.speakError(RecognizerError.recognizerIsUnavailable)
                return
            }
            
            do {
                let (audioEngine, request) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.request = request
                self.task = recognizer.recognitionTask(with: request, resultHandler: self.recognitionHandler(result:error:))
            } catch {
                self.reset()
                self.speakError(error)
            }
        }
    }
    
    func stopTranscribing() {
        reset()
    }
    
    func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func recognitionHandler(result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        if receivedFinalResult || receivedError {
            audioEngine?.stop()
            audioEngine?.inputNode.removeTap(onBus: 0)
        }
        
        if let result = result {
            speak(result.bestTranscription.formattedString)
            if isHearing {
                searchSpeak(wordsToSearch.joined(separator: " "))
            }
        }
    }
    
    private func speak(_ message: String) {
        let message = message.lowercased()
        

        let lastWordHeared = String(message.split(separator: " ").last ?? "xx \(Date())")
        guard self.lastWordHeared != lastWordHeared else {return}
//        print(lastWordHeared)

        self.lastWordHeared = lastWordHeared

        switch (lastWordHeared, isHearing) {
        case ("petro", false):
            print("Começou->", lastWordHeared)
            isHearing = true
            wordsToSearch.removeAll()
            break
        case ("pesquisar", true):     
            print("Parou->", lastWordHeared)
            isHearing = false
            break
        case (_, true):
            print("Adicionou->", lastWordHeared)
            wordsToSearch.append(lastWordHeared)
        default:
            break
        }
        
    }
    private func searchSpeak(_ messagem: String) {
        if isHearing {
            searchUser = messagem
            print("teste \(searchUser)")
        }
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
