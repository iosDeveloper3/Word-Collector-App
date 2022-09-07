//
//  Vocabulary.swift
//  Word Collector
//
//  Created by Dawid Herman on 31/08/2022.
//

import Foundation

class Vocabulary {
    
    static let shared = Vocabulary()
    
    private var savedWords: [SavedWord]
    
    var count: Int {
        return savedWords.count
    }
    
    private init() {
        savedWords = UserDefaults.standard.savedWords
    }
    
    func add(word: SavedWord?) {
        
        guard let word = word else {
            return
        }

        if !contains(word: word) {
            savedWords.append(word)
            UserDefaults.standard.savedWords = savedWords
        }
    }
    
    func remove(word: SavedWord?) {
        
        guard let word = word else {
            return
        }

        if let wordIndex = savedWords.firstIndex(where: { $0 == word }) {
            savedWords.remove(at: wordIndex)
            UserDefaults.standard.savedWords = savedWords
        }
    }
    
    func removeAllFor(fileName: String?) {
        
        guard let fileName = fileName else {
            return
        }
        
        savedWords.removeAll(where: { $0.fileName == fileName })
        UserDefaults.standard.savedWords = savedWords
    }
    
    func containsWords(from file: String?) -> Bool {
        
        guard let file = file else {
            return false
        }

        return savedWords.contains(where: { $0.fileName == file })
    }
    
    func contains(word: SavedWord?) -> Bool {
        
        guard let word = word else {
            return false
        }

        return savedWords.contains(where: { $0 == word })
    }
    
    func savedWord(at index: Int) -> SavedWord {
        return savedWords[index]
    }
    
    func word(at index: Int) -> String {
        return savedWords[index].word
    }
    
    func fileName(at index: Int) -> String {
        return savedWords[index].fileName
    }
    
    func paragraphNumber(at index: Int) -> Int {
        return savedWords[index].paragraphNumber
    }
    
    func wordNumber(at index: Int) -> Int {
        return savedWords[index].wordNumber
    }
}
