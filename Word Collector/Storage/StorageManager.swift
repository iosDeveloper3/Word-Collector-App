//
//  StorageManager.swift
//  Word Collector
//
//  Created by Dawid Herman on 24/08/2022.
//

import Foundation
import ProgressHUD

class StorageManager {
    
    private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    static func allFileNames(completion: (Bool, [String]) -> Void) {
        
        if let dir = documentDirectory {
            do {
                completion(true, try FileManager.default.contentsOfDirectory(atPath: dir.path))
            } catch {
                ProgressHUD.showError(error.localizedDescription)
                completion(false, [])
            }
        } else {
            ProgressHUD.showError(StorageInteractionError.unknownIOError.localizedDescription)
            completion(false, [])
        }
    }
    
    static func saveFile(fileName: String?, fileContent: String?) {
        
        guard let fileName = fileName, !fileName.isEmpty else {
            ProgressHUD.showError(StorageInteractionError.emptyFileName.localizedDescription)
            return
        }
        
        if let dir = documentDirectory {
            
            let fileContent = fileContent ?? ""
            let fileURL = dir.appendingPathComponent(fileName, isDirectory: false)
            
            do {
                try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                ProgressHUD.showError(error.localizedDescription)
                return
            }
        } else {
            ProgressHUD.showError(StorageInteractionError.unknownIOError.localizedDescription)
            return
        }
        
        ProgressHUD.showSuccess("File saved")
    }
}
