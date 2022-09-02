//
//  VocabularyTableViewCell.swift
//  Word Collector
//
//  Created by Dawid Herman on 31/08/2022.
//

import UIKit

class VocabularyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    func setup(savedWord: SavedWord) {
        wordLabel.text = savedWord.word
        fileNameLabel.text = savedWord.fileName
        accessibilityLabel = "See the word \(savedWord.word) in \(savedWord.fileName) file's context"
        accessibilityTraits = [.button]
    }
}
