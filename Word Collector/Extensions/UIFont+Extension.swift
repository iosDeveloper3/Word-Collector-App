//
//  UIFont+Extension.swift
//  Word Collector
//
//  Created by Dawid Herman on 25/08/2022.
//

import UIKit

extension UIFont {

    func withSize(_ size: CGFloat) -> UIFont {

        return UIFont(descriptor: fontDescriptor, size: size)
    }

    // based on https://stackoverflow.com/a/61063194 - it does not work with custom fonts like Georgia
    func withWeight(_ weight: UIFont.Weight) -> UIFont {

        let newDescriptor = fontDescriptor.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: weight
        ]])

        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}
