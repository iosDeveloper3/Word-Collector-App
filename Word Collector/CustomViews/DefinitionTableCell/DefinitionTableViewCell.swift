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
    
    func setup(definition: Definition) {
        definitionLabel.text = definition.definition
        exampleLabel.text = definition.example
    }
}
