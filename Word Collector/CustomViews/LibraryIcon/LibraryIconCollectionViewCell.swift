//
//  LibraryIconCollectionViewCell.swift
//  Word Collector
//
//  Created by Dawid Herman on 23/08/2022.
//

import UIKit

class LibraryIconCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fileLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        accessibilityTraits = [.button]
        isAccessibilityElement = true
        accessibilityHint = "Start reading"
    }

    func setup(fileName: String) {
        fileLabel.text = fileName
        accessibilityLabel = fileName
    }

}
