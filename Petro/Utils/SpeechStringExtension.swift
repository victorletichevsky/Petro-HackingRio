//
//  SpeechStringExtension.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import AVFoundation

class SpeechDefaults {
    static var voice: String = "pt-BR"
    static var pitch: Float = 1
    static var rate: Float = 0.5
    static var delegate: AVSpeechSynthesizerDelegate? {
        get { return Self.globalSpeaker.delegate }
        set { Self.globalSpeaker.delegate = newValue}
    }
    static var globalSpeaker: AVSpeechSynthesizer {
        Self.internalGlobalSpeaker = Self.internalGlobalSpeaker ?? AVSpeechSynthesizer()
        return Self.internalGlobalSpeaker
    }
    private static var internalGlobalSpeaker: AVSpeechSynthesizer!
}

extension String {
    func speak(voice: String = SpeechDefaults.voice,
               pitch: Float = SpeechDefaults.pitch,
               rate: Float = SpeechDefaults.rate,
               delegate: AVSpeechSynthesizerDelegate? = SpeechDefaults.delegate) {
        
        SpeechDefaults.voice = voice
        SpeechDefaults.pitch = pitch
        SpeechDefaults.rate = rate
        SpeechDefaults.delegate = delegate
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        
        
        let paragraphs = self.split(separator: "\n")
        guard paragraphs.count == 1 else {
            for paragraph in paragraphs {
                String(paragraph).speak()
            }
            return
        }
        
        let dialogue = AVSpeechUtterance(string: self)
        dialogue.rate = AVSpeechUtteranceDefaultSpeechRate;
        dialogue.voice = AVSpeechSynthesisVoice(language: voice)
        dialogue.pitchMultiplier = pitch
        dialogue.rate = rate
        dialogue.postUtteranceDelay = 0.5
        
        SpeechDefaults.globalSpeaker.speak(dialogue)
        
    }
    
    func stopSpeaking() {
        SpeechDefaults.globalSpeaker.stopSpeaking(at: .word)
    }
}
