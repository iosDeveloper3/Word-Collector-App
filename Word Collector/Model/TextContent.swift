//
//  TextContent.swift
//  Word Collector
//
//  Created by Dawid Herman on 04/09/2022.
//

import Foundation

struct TextContent {
    
    let text: String
    let words: [String]
    
    init(_ content: String) {
        text = content
        words = text.components(separatedBy: CharacterSet(charactersIn: " \n")).filter({ !$0.isEmpty })
    }
}
