//
//  SpeechRecognizerViewModel.swift
//
//  Petro Project
//
//  Created by Victor Letichevsky on 03/09/22.
//  Updated by Barbara Herrera, Bernardo Delgado and Luiza Bretas on 03/09/22.
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
    @Published var isSpeaking: Bool = false
    @Published var count = 0
    @Published var searchUser: String = ""
    
    @Published var users: [User] = [User.init(name: "Victor Letichevsky", competencies: "Computação", profileImage: "FotoVictorLetichevsky", tel: "99999-9999", email: "victor@petro.com.br", projetos: [Document(titulo: "Novos sistemas fotovoltaicos", autor: "Projeto Interno", descricao: "O setor fotovoltaico encontra-se hoje dominado pela tecnologia de silício cristalino onde o produto, o módulo fotovoltaico, apresenta um comportamento muito semelhante a uma commodity. Essa tecnologia apresenta características intrínsecas, decorrentes da sua própria concepção, que a descredenciam para o crescimento da produção."),Document(titulo: "Desenvolvimento de Equipamento para Avaliação de Recurso Eólico Offshore", autor: "PROJETO INTERNO", descricao: "Para a eólica em terra, a medição do recurso se baseia na instalação de torres anemométricas. No mar, a utilização de torres é possível, porém os custos associados com o projeto e instalação são muito elevados e não há flexibilidade para transporte da estrutura para diferentes locais. Para superar essas dificuldades, o uso de boias meteoceanográficas equipadas com dispositivo de sensoriamento remoto de recurso eólico (no caso, LIDARs) tem sido a solução adotada mundialmente para subsidiar o desenvolvimento e financiamento de projetos de energia eólica offshore. Atualmente, no entanto, o mercado brasileiro não possui fornecedores locais de boias com LIDAR, ficando dependente de empresas sediadas na Europa e América do Norte para coletar dados eólicos offshore. Com o desenvolvimento de um fornecedor local, espera-se que haja redução de custos e agilidade na prestação de suporte técnico, permitindo que o mapeamento do recurso eólico offshore brasileiro seja intensificado.")], password: "1234"), User(name: "Bernardo Delgado", competencies: "Engenharia", profileImage: "FotoBernardoDelgado", tel: "99999-9999", email: "bernardo@petro.com.br", projetos: [], password: "1234"), User(name: "Barbara Herrera", competencies: "Ciência da Computação", profileImage: "", tel: "99999-9999", email: "barbaraHerrera@petro.com", projetos: [], password: "1234"), User(name: "Mariana Burlamaqui", competencies: "Design", profileImage: "FotoMarianaBurlamaqui", tel: "99999-9999", email: "mariana@petro.com", projetos: [Document(titulo: "Energia elétrica de biomassa lignocelulósica", autor:"FUTURA ENERGIA SERVICOS LTDA; UNIVERSIDADE FEDERAL DO RIO DE JANEIRO/UFRJ" ,descricao: "Oportunidade de geração de energia elétrica e biogás (biometano)a partir de biomassa lignocelulósica.")], password: "1234"), User(name: "Luiza Bretas", competencies: "Engenharia", profileImage: "", tel: "99999-9999", email: "luizaBretas@petro.com", projetos: [], password: "1234")]
    
    @Published var documents: [Document] = [
        Document.init(
            titulo: "Geração de energia elétrica a partir de borras oleosas",
            autor:"UNIVERSIDADE FEDERAL DE ITAJUBÁ/UNIFEI",
            descricao: "A utilização de resíduos para a geração de energia elétrica é uma forma de aumentar a disponibilidade de insumos energéticos aliada à redução de passivos ambientais. A indústria do petróleo gera consideráveis quantidades de borra oleosa com PCI entre 15 e 20MJ/kg. Estas borras podem ser utilizadas como insumo energético para geração termelétrica por meio da geração de gás de síntese (GS) através do processo de gaseificação. Para isto, faz-se necessária a seleção adequada das tecnologias de pré-tratamento, gaseificação e do arranjo termelétrico mais propício. A destinação do resíduo para a geração de energia elétrica traz benefícios econômicos e ambientais adicionais, já que esse resíduo, considerado perigoso, possui grande custo de disposição, podendo representar riscos ao meio ambiente."),
        Document(titulo: "Energia elétrica de biomassa lignocelulósica",
                 autor:"FUTURA ENERGIA SERVICOS LTDA; UNIVERSIDADE FEDERAL DO RIO DE JANEIRO/UFRJ" ,
                 descricao: "Oportunidade de geração de energia elétrica e biogás (biometano)a partir de biomassa lignocelulósica."),
        Document(titulo: "Novos sistemas fotovoltaicos",
                 autor: "Projeto Interno",
                 descricao: "O setor fotovoltaico encontra-se hoje dominado pela tecnologia de silício cristalino onde o produto, o módulo fotovoltaico, apresenta um comportamento muito semelhante a uma commodity. Essa tecnologia apresenta características intrínsecas, decorrentes da sua própria concepção, que a descredenciam para o crescimento da produção."),
        Document(titulo: "Desenvolvimento de células solares a base de filme de Perovskita",
                 autor: "CENTRO DE INOVAÇÕES CSEM BRASIL/CSEM BRASIL UNIVERSIDADE FEDERAL DO RIO GRANDE DO NORTE/UFRN",
                 descricao: "A célula solar de perovskita (PSC) é uma das tecnologias emergentes mais promissoras para a nova geração de painéis fotovoltaicos, com eficiência teórica acima do Si cristalino e rápido desenvolvimento no meio acadêmico. Além disso, possui um potencial de baixo custo de produção podendo ser impressa em substratos flexíveis aumentando o espectro de aplicações. Projeta-se o custo da eletricidade produzida por painéis de PSC em apenas U$0,04/kWh. Apesar disso, há desafios a serem vencidos até sua efetiva viabilização comercial, relacionados à formulação/toxidez do líquido precursor, à junção do filme ativo com as demais camadas e principalmente à sua estabilidade contra condições adversas ao longo do tempo. Há clara oportunidade em investir no desenvolvimento de precursor a base de perovskita aplicável à tecnologia de impressão rolo-a-rolo, reconhecida como a mais adequada para fabricar filmes fotovoltaicos impressos em larga escala e cujo know-how é dominado no país pela CSEM Brasil."),
        Document(titulo: "Desenvolvimento de Equipamento para Avaliação de Recurso Eólico Offshore",
                 autor: "PROJETO INTERNO",
                 descricao: "Para a eólica em terra, a medição do recurso se baseia na instalação de torres anemométricas. No mar, a utilização de torres é possível, porém os custos associados com o projeto e instalação são muito elevados e não há flexibilidade para transporte da estrutura para diferentes locais. Para superar essas dificuldades, o uso de boias meteoceanográficas equipadas com dispositivo de sensoriamento remoto de recurso eólico (no caso, LIDARs) tem sido a solução adotada mundialmente para subsidiar o desenvolvimento e financiamento de projetos de energia eólica offshore. Atualmente, no entanto, o mercado brasileiro não possui fornecedores locais de boias com LIDAR, ficando dependente de empresas sediadas na Europa e América do Norte para coletar dados eólicos offshore. Com o desenvolvimento de um fornecedor local, espera-se que haja redução de custos e agilidade na prestação de suporte técnico, permitindo que o mapeamento do recurso eólico offshore brasileiro seja intensificado."),
        Document(titulo: "Planta Piloto de Geração Eólica Offshore",
                 autor: "SERVIÇO NACIONAL DE APRENDIZAGEM INDUSTRIAL/CENTRO DE TECNOLOGIAS DO GÁS E ENERGIAS RENOVÁVEIS - SENAI/SENAI; UNIVERSIDADE FEDERAL DO RIO DE JANEIRO/UFRJ; UNIVERSIDADE FEDERAL DO RIO GRANDE DO NORTE/UFRN; UNIVERSIDADE FEDERAL DE JUIZ DE FORA/UFJF",
                 descricao: "Atualmente a energia eólica onshore está em plena expansão no Brasil, sendo uma tecnologia madura, porém ainda não foi instalado nenhum aerogerador offshore no Brasil, mantendo essa tecnologia desconhecida no mercado nacional. Os estudos realizados no âmbito do projeto PD-0553-0016/2011 indicam ganho considerável de potencial em relação às áreas onshore na região avaliada."),
        Document(titulo: "Métodos de menor custo para prospecção e avaliação do potencial solar brasileiro",
                 autor: "INSTITUTO DE TECNOLOGIA PARA O DESENVOLVIMENTO/LACTEC; INSTITUTO NACIONAL DE PESQUISAS ESPACIAIS/INPE",
                 descricao: "O setor de energia solar vem experimentando um notório crescimento nos últimos no Brasil. Nesse âmbito, o projeto objetiva disponibilizar metodologias e tecnologias de menor custo para levantamento e avaliação do recurso solar, em adequados níveis de confiabilidade e incerteza de medição. Os resultados esperados se mostram importantes para prospecção de locais para possível instalação de futuros empreendimentos solares. Prevê-se a contratação de renomadas instituições de pesquisa e empresas reconhecidamente capacitadas para o desenvolvimento dos produtos propostos. A escolha realizada das instituições ainda não é definitiva, estando sujeita a modificações.")]
    
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
            return documents.filter { $0.titulo.localizedStandardContains(searchUser) || $0.autor.localizedStandardContains(searchUser) || $0.descricao.localizedStandardContains(searchUser)
            }
        }
    }
    
    private lazy var speechDelegate:SpeechSynthesizerDelegate = SpeechSynthesizerDelegate(parent: self)
    
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
    
    static let audioEngine = AVAudioEngine()
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        
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
        guard !SpeechDefaults.globalSpeaker.isSpeaking else {return}
        
        let message = message.lowercased()
        
        var searching = ""
        var startSearching = ""
        
        let lastWordHeared = String(message.split(separator: " ").last ?? "xx \(Date())")
        guard self.lastWordHeared != lastWordHeared else {return}
        
        self.lastWordHeared = lastWordHeared
        
        switch (lastWordHeared, isHearing) {
        case ("petro", false):
            print("Começou->", lastWordHeared)
            startSearching = "Pesquise..."
            
            startSearching.speak(delegate: speechDelegate)
            isHearing = true
            wordsToSearch.removeAll()
            break
        case ("pesquisar", true):     
            print("Parou->", lastWordHeared)
            searching = "Pesquisando..."
            searching.speak(delegate: speechDelegate)
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

class SpeechSynthesizerDelegate: NSObject, AVSpeechSynthesizerDelegate {
    
    var parent: SpeechRecognizerViewModel
    
    init(parent: SpeechRecognizerViewModel) {
        self.parent = parent
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        SpeechRecognizerViewModel.audioEngine.stop()
        print("Parou")
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        try? SpeechRecognizerViewModel.audioEngine.start()
        print("Restartou")
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
