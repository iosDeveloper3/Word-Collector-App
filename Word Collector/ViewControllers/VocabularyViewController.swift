//
//  VocabularyViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 31/08/2022.
//

import UIKit

class VocabularyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let vocabulary = Vocabulary.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: VocabularyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: VocabularyTableViewCell.identifier)
    }

}

extension VocabularyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabulary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VocabularyTableViewCell.identifier, for: indexPath) as? VocabularyTableViewCell else {
            fatalError()
        }
        cell.setup(savedWord: vocabulary.savedWord(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = FileViewController.instantiate() {
            vc.fileName = vocabulary.fileName(at: indexPath.row)
            vc.word = vocabulary.word(at: indexPath.row)
            vc.wordLocation = vocabulary.locationInFile(at: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
