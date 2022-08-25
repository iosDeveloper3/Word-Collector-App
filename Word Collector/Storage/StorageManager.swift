//
//  StorageManager.swift
//  Word Collector
//
//  Created by Dawid Herman on 24/08/2022.
//

import Foundation

class StorageManager {
    
    private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    static func allFileNames(completion: (Result<[String], Error>) -> Void) {
        
        if let dir = documentDirectory {
            do {
                completion(.success(try FileManager.default.contentsOfDirectory(atPath: dir.path)))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(StorageInteractionError.unknownIOError))
        }
    }
    
    static func saveFile(fileName: String?, fileContent: String?) throws {
        
        guard let fileName = fileName, !fileName.isEmpty else {
            throw StorageInteractionError.emptyFileName
        }
        
        if let dir = documentDirectory {
            
            let fileContent = fileContent ?? ""
            let fileURL = dir.appendingPathComponent(fileName, isDirectory: false)
            
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
        } else {
            throw StorageInteractionError.unknownIOError
        }
    }
    
    static func readFile(fileName: String?) throws -> String {
        
        guard let fileName = fileName, !fileName.isEmpty else {
            throw StorageInteractionError.emptyFileName
        }
        
        if let dir = documentDirectory {
            
            let fileUrl = dir.appendingPathComponent(fileName, isDirectory: false)
            
            return try String(contentsOf: fileUrl, encoding: .utf8)
        } else {
            throw StorageInteractionError.unknownIOError
        }
    }
}
