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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveFile()
    }
    
    private func saveFile() {
        
        guard let fileName = fileNameTextField.text, !fileName.isEmpty else {
            ProgressHUD.showError("Empty file name")
            return
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileContent = fileContentTextView.text ?? ""
            let fileURL = dir.appendingPathComponent(fileName, isDirectory: false)
            
            do {
                try fileContent.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                ProgressHUD.showError(error.localizedDescription)
                return
            }
        } else {
            ProgressHUD.showError("Unknown IO error")
            return
        }
        
        ProgressHUD.showSuccess("File saved")
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        saveFile()
    }
}
