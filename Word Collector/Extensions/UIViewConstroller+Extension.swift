//
//  UIViewConstroller+Extension.swift
//  Word Collector
//
//  Created by Dawid Herman on 31/08/2022.
//

import UIKit

extension UIViewController {

    static var identifier: String {
        return String(describing: self)
    }

    static func instantiate() -> Self? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? Self
    }
}
