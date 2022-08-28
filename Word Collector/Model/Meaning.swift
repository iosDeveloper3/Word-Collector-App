//
//  Meaning.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

struct Meaning: Decodable {
    let partOfSpeech: String?
    let definitions: [Definition]?
    let synonyms: [String]?
    let antonyms: [String]?
}
