//
//  FileViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 25/08/2022.
//

import UIKit

class FileViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var fileName: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            contentTextView.text = try StorageManager.readFile(fileName: fileName)
            title = fileName
        } catch {
            title = "Error"
            contentTextView.text = error.localizedDescription
        }
    }

}
