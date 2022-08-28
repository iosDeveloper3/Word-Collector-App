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
    
    var fileName: String?
    var fileContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.navigationController as? CustomNavigationViewController)?.backDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fileNameTextField.text = fileName
        fileContentTextView.text = fileContent
        fileNameTextField.isUserInteractionEnabled = (fileName == nil)
    }
    
    @discardableResult private func saveChanges(ignoreUnnamedFile: Bool) -> Bool {
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
    
    func goToPreviousViewController() {
        navigationController?.popViewController(animated: true)
        (navigationController as? CustomNavigationViewController)?.backDelegate = nil
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        saveChanges(ignoreUnnamedFile: false)
        fileName = fileNameTextField.text
        fileContent = fileContentTextView.text
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Delete file", message: "Are you sure you want to delete this file? You can't undo this action.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            do {
                try StorageManager.deleteFile(fileName: self?.fileNameTextField.text)
                ProgressHUD.showSuccess("File deleted")
                self?.navigationController?.popToRootViewController(animated: true)
            } catch {
                ProgressHUD.showError(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(alert, animated: true)
    }
    
}

extension CreateOrEditViewController: CustomNavigationViewControllerDelegate {
    
    func shouldPop() -> Bool {
        
        if fileName ?? "" == fileNameTextField.text ?? "" && fileContent ?? "" == fileContentTextView.text ?? "" {
            return true
        }
        
        let alert = UIAlertController(title: "Unsaved changes", message: "What would you like to do with them? You can't undo this action.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if self?.saveChanges(ignoreUnnamedFile: true) ?? false {
                self?.goToPreviousViewController()
            }
        }))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { [weak self] _ in
            self?.goToPreviousViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
        
        return false
    }
}
