//
//  TappedWordsRecognizingTextView.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import UIKit

protocol TappedWordsRecognizingTextViewDelegate: AnyObject {
    
    func wordDidSelected(_ textView: TappedWordsRecognizingTextView, selectedWord: String?, selectionStartPosition: Int?)
    
    func wordDidUnselected(_ textView: TappedWordsRecognizingTextView)
}

class TappedWordsRecognizingTextView: UITextView {
    
    weak var tappedWordsRecognizingDelegate: TappedWordsRecognizingTextViewDelegate?
    
    private var underlineRange: NSRange? {
        willSet {
            removeUnderline(range: underlineRange)
        }
        didSet {
            addUnderline(range: underlineRange)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        
        underlineRange = nil
        
        tappedWordsRecognizingDelegate?.wordDidUnselected(self)
    }

    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let position = sender.location(in: self)
        
        guard let tapPos = closestPosition(to: position),
              let wordRange = tokenizer.rangeEnclosingPosition(tapPos, with: .word, inDirection: UITextDirection(rawValue: NSWritingDirection.leftToRight.rawValue))
        else {
            return
        }
        
        underlineRange = NSRange(location: offset(from: beginningOfDocument, to: wordRange.start), length: offset(from: wordRange.start, to: wordRange.end))
        
        tappedWordsRecognizingDelegate?.wordDidSelected(self, selectedWord: text(in: wordRange), selectionStartPosition: underlineRange?.location)
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
        
        tappedWordsRecognizingDelegate?.wordDidSelected(self, selectedWord: word, selectionStartPosition: position)
    }
}
