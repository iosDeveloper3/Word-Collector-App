//
//  UserDefaults+Extension.swift
//  Word Collector
//
//  Created by Dawid Herman on 26/08/2022.
//

import Foundation
import UIKit

extension UserDefaults {
    
    func optionalFloat(forKey key: String) -> Float? {
        if let value = value(forKey: key) {
            return value as? Float
        }
        return nil
    }
    
    var fontSize: Float? {
        get { return optionalFloat(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var fontWeight: Float? {
        get { return optionalFloat(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var colorScheme: Int {
        get { return integer(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
