//
//  UserDefaults+Extension.swift
//  Word Collector
//
//  Created by Dawid Herman on 26/08/2022.
//

import Foundation
import UIKit

extension UserDefaults {
    
    func optionalFloat(forKey key: String) -> Float? {
        if let value = value(forKey: key) {
            return value as? Float
        }
        return nil
    }
    
    var fontSize: Float? {
        get { return optionalFloat(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var fontWeight: Float? {
        get { return optionalFloat(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var colorScheme: Int {
        get { return integer(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var savedWords: [SavedWord] {
        get {
            guard
                let words = object(forKey: #function + SavedWord.wordId) as? [String],
                let fileNames = object(forKey: #function + SavedWord.fileNameId) as? [String],
                let paragraphNumbers = object(forKey: #function + SavedWord.paragraphNumberId) as? [Int],
                let wordNumbers = object(forKey: #function + SavedWord.wordNumberId) as? [Int],
                words.count == fileNames.count && fileNames.count == paragraphNumbers.count && paragraphNumbers.count == wordNumbers.count
            else {
                return [SavedWord]()
            }
            
            var result = [SavedWord]()
            for i in 0 ..< words.count {
                result.append(SavedWord(word: words[i], fileName: fileNames[i], paragraphNumber: paragraphNumbers[i], wordNumber: wordNumbers[i]))
            }
            
            return result
        }
        set {
            var words = [String]()
            var fileNames = [String]()
            var paragraphNumbers = [Int]()
            var wordNumbers = [Int]()
            
            for savedWord in newValue {
                words.append(savedWord.word)
                fileNames.append(savedWord.fileName)
                paragraphNumbers.append(savedWord.paragraphNumber)
                wordNumbers.append(savedWord.wordNumber)
            }
            
            set(words, forKey: #function + SavedWord.wordId)
            set(fileNames, forKey: #function + SavedWord.fileNameId)
            set(paragraphNumbers, forKey: #function + SavedWord.paragraphNumberId)
            set(wordNumbers, forKey: #function + SavedWord.wordNumberId)
        }
    }
}
