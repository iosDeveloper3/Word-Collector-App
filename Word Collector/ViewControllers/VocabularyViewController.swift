//
//  VocabularyViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 31/08/2022.
//

import UIKit

class VocabularyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let savedWords = UserDefaults.standard.savedWords
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: VocabularyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: VocabularyTableViewCell.identifier)
    }

}

extension VocabularyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VocabularyTableViewCell.identifier, for: indexPath) as? VocabularyTableViewCell else {
            fatalError()
        }
        cell.setup(savedWord: savedWords[indexPath.row])
        return cell
    }
    
    // TODO: didselect...
}
