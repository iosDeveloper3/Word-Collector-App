//
//  Vocabulary.swift
//  Word Collector
//
//  Created by Dawid Herman on 31/08/2022.
//

import Foundation

struct Vocabulary {
    
    private var savedWords: [SavedWord]
    
    init(savedWords: [SavedWord]) {
        self.savedWords = UserDefaults.standard.savedWords
    }
    
    func getSavedWords() -> [SavedWord] {
        return savedWords
    }
    
    mutating func add(word: SavedWord?) {
        
        guard let word = word else {
            return
        }

        if !contains(word: word) {
            savedWords.append(word)
        }
    }
    
    mutating func remove(word: SavedWord?) {
        
        guard let word = word else {
            return
        }

        if let wordIndex = savedWords.firstIndex(where: { $0 == word }) {
            savedWords.remove(at: wordIndex)
        }
    }
    
    mutating func removeAllFor(fileName: String) {
        savedWords.removeAll(where: { $0.fileName == fileName })
    }
    
    func contains(word: SavedWord?) -> Bool {
        
        guard let word = word else {
            return false
        }

        return savedWords.contains(where: { $0 == word })
    }
}
