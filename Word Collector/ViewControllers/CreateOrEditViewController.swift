//
//  CreateOrEditViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 24/08/2022.
//

import UIKit

class CreateOrEditViewController: UIViewController {

    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var fileContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StorageManager.saveFile(fileName: fileNameTextField.text, fileContent: fileContentTextView.text)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        StorageManager.saveFile(fileName: fileNameTextField.text, fileContent: fileContentTextView.text)
    }
}
