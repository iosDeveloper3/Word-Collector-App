//
//  Entry.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

struct Entry: Decodable {
    let word: String?
    let phonetic: String?
    let phonetics: [Phonetic]?
    let meanings: [Meaning]?
    let license: License?
    let sourceUrls: [String]?
}
