//
//  StorageInteractionError.swift
//  Word Collector
//
//  Created by Dawid Herman on 24/08/2022.
//

import Foundation

enum StorageInteractionError: Error {
    case unknownIOError
    case emptyFileName
}

extension StorageInteractionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownIOError:
            return NSLocalizedString("Unknown IO error", comment: "Something strange has happened.")
        case .emptyFileName:
            return NSLocalizedString("Empty file name", comment: "File name must not be empty.")
        }
    }
}
