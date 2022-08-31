//
//  TappedWordsRecognizingTextView.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import UIKit

class TappedWordsRecognizingTextView: UITextView {
    
    private var underlineRange: NSRange? {
        willSet {
            removeUnderline(range: underlineRange)
        }
        didSet {
            addUnderline(range: underlineRange)
        }
    }
    var handleWordAndPosition: ((String?, Int?) -> Void)?
    var undoWordAndPosition: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        
        underlineRange = nil
        
        undoWordAndPosition?()
    }

    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let position = sender.location(in: self)
        
        guard let tapPos = closestPosition(to: position),
              let wordRange = tokenizer.rangeEnclosingPosition(tapPos, with: .word, inDirection: UITextDirection(rawValue: NSWritingDirection.leftToRight.rawValue))
        else {
            return
        }
        
        underlineRange = NSRange(location: offset(from: beginningOfDocument, to: wordRange.start), length: offset(from: wordRange.start, to: wordRange.end))
        
        handleWordAndPosition?(text(in: wordRange), underlineRange?.location)
    }
    
    private func addUnderline(range: NSRange?) {
        if let range = range {
            let newAttributedText = NSMutableAttributedString(attributedString: attributedText)
            newAttributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            attributedText = newAttributedText
        }
    }
    
    private func removeUnderline(range: NSRange?) {
        if let range = range {
            let newAttributedText = NSMutableAttributedString(attributedString: attributedText)
            newAttributedText.removeAttribute(NSAttributedString.Key.underlineStyle, range: range)
            attributedText = newAttributedText
        }
    }
    
    func tap(word: String, starting position: Int) {
        
        underlineRange = NSRange(location: position, length: word.count)
        
        handleWordAndPosition?(word, position)
    }
}
