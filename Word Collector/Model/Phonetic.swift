//
//  Phonetic.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

struct Phonetic: Decodable {
    let text: String?
    let audio: String?
    let sourceUrl: String?
    let license: License?
}
