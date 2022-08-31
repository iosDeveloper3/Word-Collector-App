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
                let locationsInFile = object(forKey: #function + SavedWord.locationInFileId) as? [Int],
                words.count == fileNames.count && words.count == locationsInFile.count
            else {
                return [SavedWord]()
            }
            
            var result = [SavedWord]()
            for i in 0 ..< words.count {
                result.append(SavedWord(word: words[i], fileName: fileNames[i], locationInFile: locationsInFile[i]))
            }
            
            return result
        }
        set {
            var words = [String]()
            var fileNames = [String]()
            var locationsInFile = [Int]()
            
            for savedWord in newValue {
                words.append(savedWord.word)
                fileNames.append(savedWord.fileName)
                locationsInFile.append(savedWord.locationInFile)
            }
            
            set(words, forKey: #function + SavedWord.wordId)
            set(fileNames, forKey: #function + SavedWord.fileNameId)
            set(locationsInFile, forKey: #function + SavedWord.locationInFileId)
        }
    }
}
