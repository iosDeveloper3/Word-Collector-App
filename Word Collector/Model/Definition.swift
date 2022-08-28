//
//  Definition.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

struct Definition: Decodable {
    let definition: String?
    let synonyms: [String]?
    let antonyms: [String]?
    let example: String?
}
