//
//  UILabel+Extension.swift
//  Word Collector
//
//  Created by Dawid Herman on 04/09/2022.
//

import Foundation
import UIKit

extension UILabel {
    func addUnderline() {
        
        let safeAttributedText = attributedText ?? NSAttributedString(string: text ?? "")
        let newAttributedText = NSMutableAttributedString(attributedString: safeAttributedText)
        newAttributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: safeAttributedText.string.count))
        
        attributedText = newAttributedText
    }
    
    func removeUnderline() {
        
        let safeAttributedText = attributedText ?? NSAttributedString(string: text ?? "")
        let newAttributedText = NSMutableAttributedString(attributedString: safeAttributedText)
        newAttributedText.removeAttribute(NSAttributedString.Key.underlineStyle, range: NSRange(location: 0, length: safeAttributedText.string.count))
        
        attributedText = newAttributedText
    }
}
