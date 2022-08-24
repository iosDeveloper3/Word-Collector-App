//
//  LibraryViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 23/08/2022.
//

import UIKit
import ProgressHUD

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fileNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: LibraryIconCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: LibraryIconCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        StorageManager.allFileNames { [weak self] success, data in
            if success {
                self?.fileNames = data
                self?.collectionView.reloadData()
            }
        }
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
