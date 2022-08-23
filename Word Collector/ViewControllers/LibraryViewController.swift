//
//  LibraryViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 23/08/2022.
//

import UIKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fileNames = ["Bidenticulate", "Barbette II", "Batrachivorous", "Batrachivorous", "Otic.txt"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: LibraryIconCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: LibraryIconCollectionViewCell.identifier)
    }

}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryIconCollectionViewCell.identifier, for: indexPath) as? LibraryIconCollectionViewCell else {
            fatalError()
        }
        cell.setup(fileName: fileNames[indexPath.row])
        return cell
    }
}
