//
//  TextContent.swift
//  Word Collector
//
//  Created by Dawid Herman on 04/09/2022.
//

import Foundation

struct TextContent {
    
    let text: String
    let paragraphs: [[String]]
    
    init(_ content: String) {
        text = content
        let lines = text.components(separatedBy: CharacterSet(charactersIn: "\n"))
        var tmpParagraphs = [[String]]()
        for line in lines {
            tmpParagraphs.append(line.components(separatedBy: CharacterSet(charactersIn: " ")).filter({ !$0.isEmpty }))
        }
        paragraphs = tmpParagraphs
    }
}
