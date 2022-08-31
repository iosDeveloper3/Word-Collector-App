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
    static let locationInFileId = "locationInFile"
    
    let word: String
    let fileName: String
    let locationInFile: Int
    
    init(word: String, fileName: String, locationInFile: Int) {
        self.word = word
        self.fileName = fileName
        self.locationInFile = locationInFile
    }
    
    init?(word: String?, fileName: String?, locationInFile: Int?) {
        guard let word = word, let fileName = fileName, let locationInFile = locationInFile else {
            return nil
        }
        self.word = word
        self.fileName = fileName
        self.locationInFile = locationInFile
    }
}
