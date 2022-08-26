//
//  ColorScheme.swift
//  Word Collector
//
//  Created by Dawid Herman on 26/08/2022.
//

import Foundation
import UIKit

enum ColorScheme: Int {
    
    case defaultScheme = 0
    case blackOnWhite = 1
    case whiteOnBlack = 2
    case bestForReading = 3 // according to https://www.poradopedia.pl/edukacja/najlepszy-schemat-kolorow-do-czytania,1101.html
    
    var fontColor: UIColor? {
        switch self {
        case .defaultScheme:
            return .label
        case .blackOnWhite:
            return .black
        case .whiteOnBlack:
            return .white
        case .bestForReading:
            return .CustomColor.bestReadingForecolor
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .defaultScheme:
            return .CustomColor.appBackground
        case .blackOnWhite:
            return .white
        case .whiteOnBlack:
            return .black
        case .bestForReading:
            return .CustomColor.bestReadingBackcolor
        }
    }
}
