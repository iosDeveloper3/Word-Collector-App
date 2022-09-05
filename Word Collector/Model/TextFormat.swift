//
//  TextFormat.swift
//  Word Collector
//
//  Created by Dawid Herman on 05/09/2022.
//

import Foundation

struct TextFormat {
    let defaultFontSize: Float = 14
    let defaultFontWeight: Float = 3
    let defaultColorScheme: ColorScheme = .defaultScheme
    
    var fontSize: Float {
        didSet {
            UserDefaults.standard.fontSize = fontSize
        }
    }
    var fontWeight: Float {
        didSet {
            UserDefaults.standard.fontWeight = fontWeight
        }
    }
    var colorScheme: ColorScheme {
        didSet {
            UserDefaults.standard.colorScheme = colorScheme.rawValue
        }
    }
    
    init() {
        fontSize = UserDefaults.standard.fontSize ?? defaultFontSize
        fontWeight = UserDefaults.standard.fontWeight ?? defaultFontWeight
        colorScheme = ColorScheme(rawValue: UserDefaults.standard.colorScheme) ?? defaultColorScheme
    }
    
    mutating func setToDefault() {
        fontSize = defaultFontSize
        fontWeight = defaultFontWeight
        colorScheme = defaultColorScheme
    }
}
