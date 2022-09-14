//
//  SavedWord.swift
//  Word Collector
//
//  Created by Dawid Herman on 31/08/2022.
//

import Foundation

struct SavedWord: Equatable {

    static let wordId = "word"
    static let fileNameId = "fileName"
    static let paragraphNumberId = "paragraphNumber"
    static let wordNumberId = "wordNumber"

    let word: String
    let fileName: String
    let paragraphNumber: Int
    let wordNumber: Int

    init(word: String, fileName: String, paragraphNumber: Int, wordNumber: Int) {
        self.word = word
        self.fileName = fileName
        self.paragraphNumber = paragraphNumber
        self.wordNumber = wordNumber
    }

    init?(word: String?, fileName: String?, paragraphNumber: Int?, wordNumber: Int?) {
        guard let word = word, let fileName = fileName, let paragraphNumber = paragraphNumber, let wordNumber = wordNumber else {
            return nil
        }
        self.word = word
        self.fileName = fileName
        self.paragraphNumber = paragraphNumber
        self.wordNumber = wordNumber
    }
}
