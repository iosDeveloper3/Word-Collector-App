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
    
    private var audioPlayer: AVAudioPlayer?
    
    init(_ entries: [Entry]) {
        
        var bestPhonetic: String?
        var bestAudio: String?
        
        for entry in entries {
            bestPhonetic = bestPhonetic ?? entry.phonetic?.presence
            for phoneticStruct in entry.phonetics ?? [] {
                bestPhonetic = bestPhonetic ?? phoneticStruct.text?.presence
                bestAudio = bestAudio ?? phoneticStruct.audio?.presence
            }
        }
        
        self.phonetic = bestPhonetic
        
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
