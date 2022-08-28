//
//  DictionaryRoute.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

enum DictionaryRoute: Route {
    
    var baseUrl: String {
        return "https://api.dictionaryapi.dev/api/v2/"
    }
    
    case entries(String)
    
    var endpoint: String {
        switch self {
        case .entries(let word):
            return "entries/en/\(word)/"
        }
    }
}
