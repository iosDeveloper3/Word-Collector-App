//
//  CreateOrEditViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 24/08/2022.
//

import UIKit
import ProgressHUD

class CreateOrEditViewController: UIViewController {

    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var fileContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.navigationController as? CustomNavigationViewController)?.backDelegate = self
    }
    
    private func saveChanges(ignoreUnnamedFile: Bool) -> Bool {
        do {
            try StorageManager.saveFile(fileName: fileNameTextField.text, fileContent: fileContentTextView.text)
            ProgressHUD.showSuccess("File saved")
            return true
        } catch {
            if let error = error as? StorageInteractionError, ignoreUnnamedFile && error == .emptyFileName {
                return true
            } else {
                ProgressHUD.showError(error.localizedDescription)
                return false
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        saveChanges(ignoreUnnamedFile: false)
    }
}

extension CreateOrEditViewController: CustomNavigationViewControllerDelegate {
    
    func shouldPop() -> Bool {
        
        let alert = UIAlertController(title: "Unsaved changes", message: "What would you like to do with them? You can't undo this action.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if self?.saveChanges(ignoreUnnamedFile: true) ?? false {
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
        
        return false
    }
}
