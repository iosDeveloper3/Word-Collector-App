//
//  TappedWordsRecognizingTextView.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import UIKit

class TappedWordsRecognizingTextView: UITextView {
    
    var handleWordAndPosition: ((String?, UITextRange?) -> Void)?
    var undoWordAndPosition: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        undoWordAndPosition?()
    }

    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let position = sender.location(in: self)
        
        guard let tapPos = closestPosition(to: position),
              let wordRange = tokenizer.rangeEnclosingPosition(tapPos, with: .word, inDirection: UITextDirection(rawValue: NSWritingDirection.leftToRight.rawValue))
        else {
            return
        }
        
        handleWordAndPosition?(text(in: wordRange), wordRange)
    }
}
