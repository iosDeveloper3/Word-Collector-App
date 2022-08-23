//
//  LibraryIconCollectionViewCell.swift
//  Word Collector
//
//  Created by Dawid Herman on 23/08/2022.
//

import UIKit

class LibraryIconCollectionViewCell: UICollectionViewCell {
    
//    static let identifier = String(describing: LibraryIconCollectionViewCell.self)
    
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(fileName: String) {
        fileImageView.image = UIImage(systemName: "doc.text")
        fileLabel.text = fileName
    }

}
