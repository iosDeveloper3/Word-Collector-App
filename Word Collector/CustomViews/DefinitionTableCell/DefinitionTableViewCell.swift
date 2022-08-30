//
//  DefinitionTableViewCell.swift
//  Word Collector
//
//  Created by Dawid Herman on 29/08/2022.
//

import UIKit

class DefinitionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var synonymsLabel: UILabel!
    @IBOutlet weak var antonymsLabel: UILabel!
    
    func setup(definition: Definition) {
        definitionLabel.text = definition.definition
        exampleLabel.text = definition.example
        synonymsLabel.text = definition.synonyms?.joined(separator: ", ").ifNotEmptyWith(prefix: "Synonyms: ")
        antonymsLabel.text = definition.antonyms?.joined(separator: ", ").ifNotEmptyWith(prefix: "Antonyms: ")
    }
}
