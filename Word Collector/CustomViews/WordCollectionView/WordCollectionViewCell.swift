//
//  WordCollectionViewCell.swift
//  Word Collector
//
//  Created by Dawid Herman on 04/09/2022.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var wordLabel: UILabel!
    
    func setup(word: String?) {
        wordLabel.text = word
    }
}
