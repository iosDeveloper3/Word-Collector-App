//
//  String+Extension.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

extension String {
    var presence: String? {
        return isEmpty ? nil : self
    }
    
    func ifNotEmptyWith(prefix: String) -> String {
        return isEmpty ? self : prefix + self
    }
}
