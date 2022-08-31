//
//  DictionaryTerm.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation
import AVFoundation

class DictionaryTerm {
    
    let phonetic: String?
    let partsOfSpeach: [String]
    let information: [[Definition]]
    
    private var audioPlayer: AVAudioPlayer?
    
    init(_ entries: [Entry]) {
        
        var bestPhonetic: String?
        var bestAudio: String?
        var bestDefinitions: [String: [Definition]] = [:]
        
        for entry in entries {
            bestPhonetic = bestPhonetic ?? entry.phonetic?.presence
            for phoneticStruct in entry.phonetics ?? [] {
                bestPhonetic = bestPhonetic ?? phoneticStruct.text?.presence
                bestAudio = bestAudio ?? phoneticStruct.audio?.presence
            }
            for meaning in entry.meanings ?? [] {
                if let partOfSpeech = meaning.partOfSpeech {
                    var partOfSpeechSet = bestDefinitions[partOfSpeech] ?? []
                    partOfSpeechSet += meaning.definitions ?? []
                    bestDefinitions[partOfSpeech] = partOfSpeechSet
                }
            }
        }
        
        self.phonetic = bestPhonetic
        
        var bestPartsOfSpeech = [String]()
        var bestInformation = [[Definition]]()
        for (partOfSpeech, definitions) in bestDefinitions {
            bestPartsOfSpeech.append(partOfSpeech)
            bestInformation.append(definitions)
        }
        self.partsOfSpeach = bestPartsOfSpeech
        self.information = bestInformation
        
        if let remoteURL = URL(string: bestAudio ?? "") {
            URLSession.shared.downloadTask(with: remoteURL) { [weak self] url, _, _ in
                if let localURL = url {
                    do {
                        self?.audioPlayer = try AVAudioPlayer(contentsOf: localURL)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    func playPronunciation() {
        audioPlayer?.play()
    }
}
