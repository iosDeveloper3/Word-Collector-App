//
//  TappedWordsRecognizingTextView.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import UIKit

class TappedWordsRecognizingTextView: UITextView {
    
    var handleWordAndPosition: ((String?, UITextRange?) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        let position = sender.location(in: self)
        
        guard let tapPos = closestPosition(to: position),
              let wordRange = tokenizer.rangeEnclosingPosition(tapPos, with: .word, inDirection: UITextDirection(rawValue: NSWritingDirection.leftToRight.rawValue))
        else {
            return
        }
        
        let word = text(in: wordRange)
        print("oto słowo Boże: \(word)")
        handleWordAndPosition?(word, wordRange)
    }
}
