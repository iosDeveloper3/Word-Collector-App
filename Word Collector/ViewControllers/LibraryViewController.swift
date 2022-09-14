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

    private let openFile = "openFile"

    private var fileNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: LibraryIconCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: LibraryIconCollectionViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        StorageManager.allFileNames { [weak self] result in
            switch result {
            case .success(let data):
                self?.fileNames = data
                self?.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath, let vc = segue.destination as? FileViewController {
            vc.fileName = fileNames[indexPath.row]
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: openFile, sender: indexPath)
    }
}
